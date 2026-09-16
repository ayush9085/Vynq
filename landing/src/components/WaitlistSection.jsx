import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowRight, CheckCircle2, Mail, Sparkles, User } from 'lucide-react';
import confetti from 'canvas-confetti';
import { submitWaitlistEmail, getWaitlistCount } from '../lib/supabase';

const sampleDomains = ['@gmail.com', '@icloud.com', '@outlook.com', '@yahoo.com'];

export default function WaitlistSection() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [waitlistCount, setWaitlistCount] = useState(2480);

  useEffect(() => {
    getWaitlistCount().then((count) => {
      setWaitlistCount(count);
    });

    const savedEmail = localStorage.getItem('vynk_waitlist_email');
    const savedName = localStorage.getItem('vynk_waitlist_name');
    if (savedEmail) {
      setEmail(savedEmail);
      if (savedName) setName(savedName);
      setSubmitted(true);
    }
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email || !email.includes('@')) {
      setError('Please enter a valid email address');
      return;
    }

    setError('');
    setLoading(true);

    try {
      const res = await submitWaitlistEmail(email, name);
      if (res.success) {
        setSubmitted(true);
        setWaitlistCount((prev) => prev + 1);

        try {
          confetti({
            particleCount: 120,
            spread: 90,
            origin: { y: 0.6 },
            colors: ['#FF4D67', '#7C3AED', '#FFFFFF']
          });
        } catch (err) {
          console.log('Confetti triggered');
        }
      }
    } catch (err) {
      setError('Something went wrong. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const appendDomain = (domain) => {
    if (!email) {
      setEmail(`username${domain}`);
      return;
    }
    if (domain.startsWith('@')) {
      const parts = email.split('@');
      setEmail(`${parts[0]}${domain}`);
    } else if (!email.endsWith(domain)) {
      setEmail(`${email}${domain}`);
    }
  };

  return (
    <section id="waitlist" className="py-28 px-6 max-w-5xl mx-auto z-10 relative">
      
      {/* Huge Ambient Glowing Gradient Background */}
      <div className="absolute inset-0 bg-gradient-to-r from-[#FF4D67]/20 via-[#7C3AED]/20 to-transparent rounded-[48px] blur-3xl opacity-70 pointer-events-none" />

      {/* Glass Card Container */}
      <div className="bg-[#16162A]/90 border border-white/20 rounded-[36px] p-8 sm:p-16 text-center space-y-8 shadow-2xl backdrop-blur-2xl relative overflow-hidden">
        
        {/* Subhead Badge */}
        <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-xs font-black uppercase tracking-widest text-[#FF4D67]">
          <Sparkles className="w-3.5 h-3.5" />
          <span>EARLY ACCESS ({waitlistCount.toLocaleString()}+ MEMBERS RESERVED)</span>
        </div>

        {/* Heading */}
        <h2 className="text-4xl sm:text-7xl font-black text-white tracking-tight leading-[0.95]">
          Be there <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">before everyone else.</span>
        </h2>

        {/* Supporting Copy */}
        <p className="text-base sm:text-lg text-gray-300 font-medium leading-relaxed max-w-xl mx-auto">
          Vynk is coming soon. Get early access before we open the doors.
        </p>

        {/* Form Container */}
        <AnimatePresence mode="wait">
          {!submitted ? (
            <motion.div
              key="form-container"
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className="space-y-6 max-w-xl mx-auto"
            >
              <form
                onSubmit={handleSubmit}
                className="space-y-3"
              >
                <div className="flex flex-col sm:flex-row gap-3">
                  {/* Name Input */}
                  <div className="relative flex-1">
                    <User className="w-4 h-4 text-gray-400 absolute left-4 top-1/2 -translate-y-1/2 pointer-events-none" />
                    <input
                      type="text"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      placeholder="Your Name"
                      disabled={loading}
                      className="w-full pl-11 pr-5 py-4 rounded-full bg-[#1A1A2E] border border-white/20 text-white placeholder-gray-400 focus:outline-none focus:border-[#FF4D67] text-sm font-semibold transition-all"
                    />
                  </div>

                  {/* Email Input */}
                  <div className="relative flex-1">
                    <Mail className="w-4 h-4 text-gray-400 absolute left-4 top-1/2 -translate-y-1/2 pointer-events-none" />
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="Enter your email"
                      disabled={loading}
                      className="w-full pl-11 pr-5 py-4 rounded-full bg-[#1A1A2E] border border-white/20 text-white placeholder-gray-400 focus:outline-none focus:border-[#FF4D67] text-sm font-semibold transition-all"
                    />
                  </div>
                </div>

                {error && (
                  <p className="text-xs font-bold text-[#FF4D67] text-left pl-4">
                    {error}
                  </p>
                )}

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full py-4 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] hover:from-[#FF3352] hover:to-[#6D28D9] text-white font-extrabold text-sm tracking-wider uppercase transition-all duration-300 flex items-center justify-center gap-2 cursor-pointer shadow-xl shadow-[#FF4D67]/30 hover:scale-[1.02] active:scale-[0.98]"
                >
                  <span>{loading ? 'JOINING...' : 'GET EARLY ACCESS'}</span>
                  <ArrowRight className="w-4 h-4" />
                </button>
              </form>

              {/* Supporting Note */}
              <p className="text-xs text-gray-400 font-semibold flex items-center justify-center gap-1.5">
                <span>No spam. Just the occasional wink.</span>
                <span className="text-[#FF4D67] text-sm">;)</span>
              </p>

              {/* Quick Domain Helper */}
              <div className="flex flex-wrap items-center justify-center gap-2 pt-2">
                <span className="text-[11px] text-gray-400 font-medium flex items-center gap-1">
                  <Mail className="w-3.5 h-3.5 text-[#FF4D67]" />
                  Quick domain:
                </span>
                {sampleDomains.map((domain) => (
                  <button
                    key={domain}
                    type="button"
                    onClick={() => appendDomain(domain)}
                    className="px-2.5 py-1 rounded-full bg-white/5 hover:bg-white/10 border border-white/10 text-[11px] text-gray-300 font-medium transition-colors cursor-pointer"
                  >
                    {domain}
                  </button>
                ))}
              </div>
            </motion.div>
          ) : (
            <motion.div
              key="success"
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.4 }}
              className="p-8 rounded-3xl bg-[#1A1A2E] border border-[#FF4D67]/40 text-center space-y-4 max-w-md mx-auto shadow-2xl"
            >
              <div className="w-14 h-14 rounded-full bg-[#FF4D67]/20 border border-[#FF4D67]/50 flex items-center justify-center mx-auto text-[#FF4D67]">
                <CheckCircle2 className="w-8 h-8" />
              </div>
              
              <h3 className="text-3xl font-black text-white uppercase tracking-tight">
                YOU’RE IN. 😉
              </h3>
              <p className="text-base font-bold text-[#A78BFA]">
                Welcome to Vynk{name ? `, ${name.split(' ')[0]}` : ''}.
              </p>
              <p className="text-xs text-gray-300 font-medium">
                Spot saved for <span className="text-white font-bold">{email}</span>. We'll send your invite before launch.
              </p>

              <button
                onClick={() => {
                  localStorage.removeItem('vynk_waitlist_email');
                  localStorage.removeItem('vynk_waitlist_name');
                  setSubmitted(false);
                  setEmail('');
                  setName('');
                }}
                className="text-xs text-gray-400 hover:text-white underline cursor-pointer pt-2"
              >
                Register another email
              </button>
            </motion.div>
          )}
        </AnimatePresence>

      </div>

    </section>
  );
}
