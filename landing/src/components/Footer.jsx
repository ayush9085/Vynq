import React from 'react';
import Logo from './Logo';

export default function Footer({ onOpenPrivacy, onOpenTerms, onOpenContact }) {
  return (
    <footer className="border-t border-white/10 py-16 px-6 bg-[#0D0D0D] z-10 relative">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
        
        {/* Left Brand Logo & Tagline */}
        <div className="flex flex-col items-center md:items-start text-center md:text-left space-y-2">
          <a href="#" className="flex items-center">
            <Logo size="md" />
          </a>
          <p className="text-sm font-bold text-[#FF4D67] tracking-wide">
            Personality &gt; Pictures.
          </p>
        </div>

        {/* Center / Right Links */}
        <div className="flex flex-wrap items-center justify-center gap-8 text-xs font-bold uppercase tracking-wider text-gray-400">
          <a href="https://instagram.com" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">
            Instagram
          </a>
          <button onClick={onOpenContact} className="hover:text-white transition-colors cursor-pointer">
            Contact
          </button>
          <button onClick={onOpenPrivacy} className="hover:text-white transition-colors cursor-pointer">
            Privacy
          </button>
          <button onClick={onOpenTerms} className="hover:text-white transition-colors cursor-pointer">
            Terms
          </button>
        </div>

        {/* Copyright */}
        <p className="text-xs text-gray-500 font-semibold">
          © 2026 Vynk
        </p>

      </div>
    </footer>
  );
}
