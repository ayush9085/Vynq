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
      // Send directly to the registering user's email
      let response = await resend.emails.send({
        from: RESEND_FROM,
        to: [email],
        subject: `Welcome to Vynk Early Access, ${firstName || 'friend'}! ✨`,
        html: `
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <body style="margin: 0; padding: 0; background-color: #07070C; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #E2E8F0;">
            <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color: #07070C; padding: 40px 16px;">
              <tr>
                <td align="center">
                  <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="max-width: 520px; background: linear-gradient(180deg, #131322 0%, #0D0D18 100%); border: 1px solid #232338; border-radius: 24px; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.6);">
                    
                    <!-- Top Accent Bar -->
                    <tr>
                      <td style="height: 4px; background: linear-gradient(90deg, #FF4D67 0%, #A78BFA 50%, #EC4899 100%);"></td>
                    </tr>

                    <!-- Header -->
                    <tr>
                      <td style="padding: 40px 32px 24px 32px; text-align: center;">
                        <h1 style="margin: 0; font-size: 34px; font-weight: 900; letter-spacing: -1.5px; color: #FF4D67; display: inline-block;">
                          VYNK<span style="color: #A78BFA;">.</span>
                        </h1>
                        <p style="margin: 6px 0 0 0; color: #94A3B8; font-size: 13px; font-weight: 600; letter-spacing: 1.5px; text-transform: uppercase;">
                          Personality-First Dating
                        </p>
                      </td>
                    </tr>

                    <!-- Divider -->
                    <tr>
                      <td style="padding: 0 32px;">
                        <div style="height: 1px; background: linear-gradient(90deg, transparent, #2E2E48, transparent);"></div>
                      </td>
                    </tr>

                    <!-- Body Content -->
                    <tr>
                      <td style="padding: 32px; text-align: left;">
                        <h2 style="margin: 0 0 16px 0; color: #FFFFFF; font-size: 22px; font-weight: 700; letter-spacing: -0.5px;">
                          ${greeting}You're officially on the list! ✨
                        </h2>
                        
                        <p style="margin: 0 0 20px 0; color: #94A3B8; font-size: 15px; line-height: 1.6;">
                          Thanks for joining the early access queue. We're rethinking campus dating from the ground up — ditching shallow 2-second swipes for deep compatibility, MBTI insights, and genuine vibe matches.
                        </p>

                        <!-- Reservation Card -->
                        <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="background: rgba(255, 77, 103, 0.05); border: 1px solid rgba(255, 77, 103, 0.2); border-radius: 16px; margin: 24px 0;">
                          <tr>
                            <td style="padding: 20px; text-align: left;">
                              <div style="color: #A78BFA; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px;">
                                VIP Early Access Spot Reserved
                              </div>
                              <div style="color: #FFFFFF; font-size: 15px; font-weight: 600; word-break: break-all;">
                                ${fullName ? `${fullName} (${email})` : email}
                              </div>
                              <div style="color: #10B981; font-size: 12px; font-weight: 600; margin-top: 8px;">
                                &#10003; Status: Priority Access Confirmed
                              </div>
                            </td>
                          </tr>
                        </table>

                        <p style="margin: 0 0 28px 0; color: #94A3B8; font-size: 14px; line-height: 1.6;">
                          We'll reach out directly with your exclusive invite code prior to launch. Keep an eye on your inbox!
                        </p>

                        <!-- CTA Button -->
                        <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td align="center">
                              <a href="https://vynk.space" target="_blank" style="display: inline-block; background: linear-gradient(135deg, #FF4D67 0%, #E11D48 100%); color: #FFFFFF; text-decoration: none; font-size: 15px; font-weight: 700; padding: 14px 32px; border-radius: 99px; box-shadow: 0 4px 20px rgba(255, 77, 103, 0.4);">
                                Visit vynk.space &rarr;
                              </a>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                      <td style="padding: 24px 32px 32px 32px; background-color: #0A0A12; text-align: center; border-top: 1px solid #1C1C2E;">
                        <p style="margin: 0 0 8px 0; color: #64748B; font-size: 12px;">
                          You received this because you signed up for early access at <a href="https://vynk.space" style="color: #A78BFA; text-decoration: none;">vynk.space</a>
                        </p>
                        <p style="margin: 0; color: #475569; font-size: 11px;">
                          &copy; 2026 Vynk. All rights reserved. &bull; Personality-First Dating
                        </p>
                      </td>
                    </tr>

                  </table>
                </td>
              </tr>
            </table>
          </body>
          </html>
        `
      });

      if (response && !response.error) {
        emailSent = true;
      } else if (response?.error?.message?.includes('testing emails')) {
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
