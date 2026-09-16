import React, { useState } from 'react';
import { X, ShieldCheck, FileText, Mail, Send, CheckCircle2 } from 'lucide-react';

export function PrivacyModal({ isOpen, onClose }) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-in fade-in duration-200">
      <div className="bg-[#16162A] border border-[#252542] rounded-3xl max-w-2xl w-full max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
        
        {/* Modal Header */}
        <div className="flex items-center justify-between p-6 border-b border-[#252542] bg-[#1A1A2E]">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-[#FF4D67]/20 border border-[#FF4D67]/40 flex items-center justify-center text-[#FF4D67]">
              <ShieldCheck className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-xl font-black text-white uppercase tracking-tight">PRIVACY POLICY</h3>
              <p className="text-xs text-gray-400 font-semibold">Effective Date: September 2026</p>
            </div>
          </div>
          <button 
            onClick={onClose} 
            className="p-2 rounded-full bg-[#252542] text-gray-400 hover:text-white transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Content */}
        <div className="p-6 overflow-y-auto space-y-6 text-sm text-gray-300 font-medium leading-relaxed no-scrollbar">
          
          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">1. Information We Collect</h4>
            <p>
              Vynk collects personal data that you voluntarily provide when creating an account or joining our early access waitlist. This includes your email address, profile photo, MBTI personality responses, interests, and basic profile parameters.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">2. How We Use Your Information</h4>
            <p>
              Your data is exclusively used to calculate cognitive personality compatibility scores, generate personalized AI conversation starters, verify profile authenticity, and match you with compatible members. We do not sell your personal data to third parties.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">3. Data Security & Encryption</h4>
            <p>
              We implement industry-standard encryption, Row Level Security (RLS) policies, and secure authentication infrastructure to protect your personal information against unauthorized access.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">4. Profile Verification</h4>
            <p>
              To maintain a 100% genuine human network, Vynk conducts biometric photo verification. Verification data is stored securely and never made public.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">5. Your Rights & Account Deletion</h4>
            <p>
              You maintain full ownership of your data. You may request account deletion or data export at any time by contacting our privacy team at <span className="text-[#FF4D67] font-bold">privacy@vynk.app</span>.
            </p>
          </section>

        </div>

        {/* Modal Footer */}
        <div className="p-4 border-t border-[#252542] bg-[#1A1A2E] flex justify-end">
          <button
            onClick={onClose}
            className="px-6 py-2.5 rounded-full bg-[#FF4D67] text-white font-bold text-xs uppercase tracking-wider hover:bg-[#ff3352] transition-all cursor-pointer"
          >
            I Understand
          </button>
        </div>

      </div>
    </div>
  );
}

export function TermsModal({ isOpen, onClose }) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-in fade-in duration-200">
      <div className="bg-[#16162A] border border-[#252542] rounded-3xl max-w-2xl w-full max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
        
        {/* Modal Header */}
        <div className="flex items-center justify-between p-6 border-b border-[#252542] bg-[#1A1A2E]">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-[#7C3AED]/20 border border-[#7C3AED]/40 flex items-center justify-center text-[#A78BFA]">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-xl font-black text-white uppercase tracking-tight">TERMS OF SERVICE</h3>
              <p className="text-xs text-gray-400 font-semibold">Effective Date: September 2026</p>
            </div>
          </div>
          <button 
            onClick={onClose} 
            className="p-2 rounded-full bg-[#252542] text-gray-400 hover:text-white transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Content */}
        <div className="p-6 overflow-y-auto space-y-6 text-sm text-gray-300 font-medium leading-relaxed no-scrollbar">
          
          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">1. Acceptance of Terms</h4>
            <p>
              By accessing Vynk or signing up for early access, you agree to abide by these Terms of Service and our Community Guidelines.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">2. Age Eligibility & Verification</h4>
            <p>
              You must be at least 18 years of age to use Vynk. Creating accounts on behalf of others or providing false age information will result in immediate termination.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">3. Community Standards & Respect</h4>
            <p>
              Vynk enforces a zero-tolerance policy for harassment, hate speech, non-consensual content, ghosting scam bots, or abusive behavior. Violators are permanently banned.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">4. Intellectual Property</h4>
            <p>
              All proprietary algorithms, matching matrices, Vynk branding, wordmarks, and visual designs are intellectual property owned exclusively by Vynk Inc.
            </p>
          </section>

          <section className="space-y-2">
            <h4 className="text-base font-bold text-white uppercase">5. Disclaimers & Limitation of Liability</h4>
            <p>
              Vynk provides personality matching algorithms to assist connection, but does not guarantee specific relationship outcomes. Users are responsible for exercising safety when meeting in person.
            </p>
          </section>

        </div>

        {/* Modal Footer */}
        <div className="p-4 border-t border-[#252542] bg-[#1A1A2E] flex justify-end">
          <button
            onClick={onClose}
            className="px-6 py-2.5 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] text-white font-bold text-xs uppercase tracking-wider cursor-pointer"
          >
            Accept Terms
          </button>
        </div>

      </div>
    </div>
  );
}

export function ContactModal({ isOpen, onClose }) {
  const [sent, setSent] = useState(false);
  const [msg, setMsg] = useState('');
  const [email, setEmail] = useState('');

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (email && msg) {
      setSent(true);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-in fade-in duration-200">
      <div className="bg-[#16162A] border border-[#252542] rounded-3xl max-w-lg w-full flex flex-col shadow-2xl overflow-hidden">
        
        {/* Modal Header */}
        <div className="flex items-center justify-between p-6 border-b border-[#252542] bg-[#1A1A2E]">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-[#FF4D67]/20 border border-[#FF4D67]/40 flex items-center justify-center text-[#FF4D67]">
              <Mail className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-xl font-black text-white uppercase tracking-tight">CONTACT VYNK</h3>
              <p className="text-xs text-gray-400 font-semibold">We'd love to hear from you</p>
            </div>
          </div>
          <button 
            onClick={onClose} 
            className="p-2 rounded-full bg-[#252542] text-gray-400 hover:text-white transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Content */}
        <div className="p-6 space-y-4">
          {!sent ? (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-bold text-gray-300 uppercase mb-1.5">Your Email</label>
                <input 
                  type="email" 
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="name@example.com" 
                  required
                  className="w-full px-4 py-3 rounded-xl bg-[#1A1A2E] border border-[#252542] text-white text-sm font-semibold focus:outline-none focus:border-[#FF4D67]"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-gray-300 uppercase mb-1.5">Message</label>
                <textarea 
                  rows="4" 
                  value={msg}
                  onChange={(e) => setMsg(e.target.value)}
                  placeholder="Inquiries, press, or feedback..." 
                  required
                  className="w-full px-4 py-3 rounded-xl bg-[#1A1A2E] border border-[#252542] text-white text-sm font-semibold focus:outline-none focus:border-[#FF4D67] resize-none"
                />
              </div>

              <div className="pt-2 flex justify-between items-center text-xs text-gray-400">
                <span>Or email directly: <strong className="text-white">support@vynk.app</strong></span>
                <button
                  type="submit"
                  className="px-6 py-3 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] text-white font-bold text-xs uppercase tracking-wider flex items-center gap-1.5 cursor-pointer shadow-lg shadow-[#FF4D67]/20"
                >
                  <span>SEND</span>
                  <Send className="w-3.5 h-3.5" />
                </button>
              </div>
            </form>
          ) : (
            <div className="py-8 text-center space-y-3">
              <div className="w-12 h-12 rounded-full bg-[#FF4D67]/20 border border-[#FF4D67]/50 flex items-center justify-center mx-auto text-[#FF4D67]">
                <CheckCircle2 className="w-7 h-7" />
              </div>
              <h4 className="text-xl font-black text-white uppercase">MESSAGE SENT</h4>
              <p className="text-xs text-gray-300 font-medium">
                Thanks for reaching out! Our team will get back to you shortly at <span className="text-white font-bold">{email}</span>.
              </p>
              <button
                onClick={() => setSent(false)}
                className="text-xs text-[#FF4D67] hover:underline font-bold pt-2 cursor-pointer"
              >
                Send another message
              </button>
            </div>
          )}
        </div>

      </div>
    </div>
  );
}
