import React, { useState, useEffect } from 'react';
import { ArrowRight, Menu, X } from 'lucide-react';
import Logo from './Logo';

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const scrollToSection = (id) => {
    setMobileMenuOpen(false);
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <header className="fixed top-0 left-0 right-0 z-50 px-4 sm:px-6 py-4 transition-all duration-300">
      <div className={`max-w-6xl mx-auto rounded-full transition-all duration-300 ${
        scrolled 
          ? 'bg-[#16162A]/90 backdrop-blur-xl border border-white/10 shadow-2xl py-2.5 px-6' 
          : 'bg-white/[0.05] backdrop-blur-md border border-white/10 py-3 px-6'
      } flex items-center justify-between`}>
        
        {/* Vynk Brand Logo ("THE WINK") */}
        <a href="#" className="flex items-center">
          <Logo size="md" />
        </a>

        {/* Desktop Links */}
        <nav className="hidden md:flex items-center gap-8 text-sm font-semibold tracking-wide text-gray-300">
          <button 
            onClick={() => scrollToSection('how-it-works')} 
            className="hover:text-white transition-colors duration-200 cursor-pointer"
          >
            How it works
          </button>
          <button 
            onClick={() => scrollToSection('compatibility')} 
            className="hover:text-white transition-colors duration-200 cursor-pointer"
          >
            Compatibility
          </button>
          <button 
            onClick={() => scrollToSection('waitlist')} 
            className="hover:text-[#FF4D67] transition-colors duration-200 cursor-pointer"
          >
            Early Access
          </button>
        </nav>

        {/* Right CTA Button & Mobile Toggle */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => scrollToSection('waitlist')}
            className="px-5 py-2 sm:px-6 sm:py-2.5 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] hover:from-[#FF3352] hover:to-[#6D28D9] text-white font-extrabold text-xs sm:text-sm tracking-wider uppercase transition-all duration-300 shadow-lg shadow-[#FF4D67]/25 hover:scale-105 active:scale-95 flex items-center gap-1.5 cursor-pointer"
          >
            <span>JOIN WAITLIST</span>
            <ArrowRight className="w-3.5 h-3.5 sm:w-4 sm:h-4" />
          </button>

          {/* Mobile Hamburger Menu */}
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="md:hidden p-2 text-gray-300 hover:text-white cursor-pointer"
            aria-label="Toggle Menu"
          >
            {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
          </button>
        </div>

      </div>

      {/* Mobile Glass Navigation Drawer */}
      {mobileMenuOpen && (
        <div className="md:hidden mt-3 max-w-6xl mx-auto rounded-3xl bg-[#16162A]/95 backdrop-blur-2xl border border-white/10 p-6 shadow-2xl space-y-4 animate-in fade-in duration-200">
          <div className="flex flex-col space-y-3 text-sm font-bold text-gray-200">
            <button
              onClick={() => scrollToSection('how-it-works')}
              className="text-left py-2 px-3 rounded-xl hover:bg-white/5 transition-colors"
            >
              How it works
            </button>
            <button
              onClick={() => scrollToSection('compatibility')}
              className="text-left py-2 px-3 rounded-xl hover:bg-white/5 transition-colors"
            >
              Compatibility
            </button>
            <button
              onClick={() => scrollToSection('waitlist')}
              className="text-left py-2 px-3 rounded-xl hover:bg-white/5 transition-colors text-[#FF4D67]"
            >
              Early Access
            </button>
          </div>
        </div>
      )}
    </header>
  );
}
