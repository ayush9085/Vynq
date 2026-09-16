/**
 * Vercel Serverless Function: /api/waitlist
 * Handles waitlist signups, Supabase database storage, and confirmation email dispatch.
 */

import { createClient } from '@supabase/supabase-js';
import { Resend } from 'resend';

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://hmkcbqfdyvcnwawpjzwx.supabase.co';
const SUPABASE_ANON_KEY = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'sb_publishable_xv29JM9FoZfVbYpQhIlJag_yEYBhMMO';
const RESEND_API_KEY = process.env.RESEND_API_KEY;
const RESEND_FROM = process.env.RESEND_FROM || 'Vynk <welcome@vynk.space>';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
const resend = RESEND_API_KEY ? new Resend(RESEND_API_KEY) : null;

export default async function handler(req, res) {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    try {
      const { count, error } = await supabase
        .from('waitlist')
        .select('*', { count: 'exact', head: true });

      const totalCount = (error || count === null) ? 2480 : count + 2480;
      return res.status(200).json({ count: totalCount });
    } catch (err) {
      return res.status(200).json({ count: 2480 });
    }
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { email, name } = req.body || {};

  if (!email || !email.includes('@')) {
    return res.status(400).json({ error: 'Please enter a valid email address' });
  }

  const domain = email.split('@')[1] || 'unknown';
  const fullName = (name || '').trim();
  const firstName = fullName ? fullName.split(' ')[0] : '';
  const greeting = firstName ? `Hey ${firstName}, ` : 'Hey there, ';

  let dbSuccess = false;
  let emailSent = false;
  let duplicate = false;

  // 1. Insert into Supabase Waitlist Table
  try {
    let insertPayload = { email, campus_domain: domain, status: 'pending' };
    if (fullName) {
      insertPayload.name = fullName;
    }

    let { data, error } = await supabase
      .from('waitlist')
      .insert([insertPayload]);

    if (error && (error.message?.includes('column "name"') || error.code === 'PGRST204')) {
      // Retry without name column if schema has not added name column yet
      delete insertPayload.name;
      const retry = await supabase.from('waitlist').insert([insertPayload]);
      error = retry.error;
    }

    if (!error) {
      dbSuccess = true;
    } else if (error.code === '23505' || error.message?.includes('duplicate')) {
      dbSuccess = true;
      duplicate = true;
    } else {
      console.warn('Supabase Insert Notice:', error.message);
    }
  } catch (err) {
    console.warn('Supabase DB Notice:', err.message);
  }

  // 2. Send Confirmation Email via Resend SDK directly to user
  if (RESEND_API_KEY && resend) {
    try {
      // First attempt: Send directly to the registering user's email
      let response = await resend.emails.send({
        from: RESEND_FROM,
        to: [email],
        subject: `Welcome to Vynk Early Access, ${firstName || 'friend'}! 😉`,
        html: `
          <div style="background-color: #0D0D0D; color: #FFFFFF; font-family: sans-serif; padding: 40px 20px; text-align: center;">
            <div style="max-width: 500px; margin: 0 auto; background-color: #16162A; border: 1px solid #252542; border-radius: 24px; padding: 32px;">
              <h1 style="color: #FF4D67; font-size: 32px; font-weight: 900; letter-spacing: -1px; margin-bottom: 8px;">VYNK;</h1>
              <p style="color: #A78BFA; font-size: 14px; font-weight: 700; text-transform: uppercase; tracking: 2px;">Personality-First Dating</p>
              <hr style="border: 0; border-top: 1px solid #252542; margin: 24px 0;" />
              <h2 style="color: #FFFFFF; font-size: 24px; font-weight: 800; margin-bottom: 12px;">${greeting.toUpperCase()}YOU'RE ON THE LIST. 😉</h2>
              <p style="color: #9CA3AF; font-size: 15px; line-height: 1.6; margin-bottom: 24px;">
                Thanks for joining the Vynk early access queue! We're building personality-first dating for people who want more than a 2-second swipe.
              </p>
              <div style="background-color: #1A1A2E; border: 1px solid #252542; border-radius: 16px; padding: 16px; color: #FF4D67; font-weight: 700; font-size: 14px;">
                Spot Reserved for: ${fullName ? `${fullName} (${email})` : email}
              </div>
              <p style="color: #6B7280; font-size: 12px; margin-top: 24px;">
                We'll send your exclusive invite code prior to launch. No spam. Just a little wink.
              </p>
            </div>
          </div>
        `
      });

      if (response && !response.error) {
        emailSent = true;
      } else if (response?.error?.message?.includes('testing emails')) {
        // Backup during Resend testing mode: forward copy to heyvynk@gmail.com
        console.warn('Resend domain unverified: forwarding testing copy to heyvynk@gmail.com');
        await resend.emails.send({
          from: RESEND_FROM,
          to: ['heyvynk@gmail.com'],
          subject: `[Vynk Waitlist Signup] Welcome email for ${email}`,
          html: `<p>New waitlist signup for <strong>${email}</strong>. (Verify domain on Resend.com to deliver directly to user).</p>`
        });
      }
    } catch (err) {
      console.warn('Resend email error:', err);
    }
  }

  return res.status(200).json({
    success: true,
    email,
    dbSuccess,
    duplicate,
    emailSent,
    message: duplicate ? 'Email already registered on waitlist.' : 'Welcome to Vynk waitlist!'
  });
}
