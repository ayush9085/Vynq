import React from 'react';
import { motion } from 'framer-motion';
import { ArrowRight, ArrowDown } from 'lucide-react';
import AppStoreBadges from './AppStoreBadges';

export default function Hero() {
  const scrollToWaitlist = () => {
    const element = document.getElementById('waitlist');
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const scrollToExplore = () => {
    const element = document.getElementById('how-it-works');
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <section className="relative min-h-[92vh] pt-32 sm:pt-40 pb-20 px-4 w-full flex flex-col justify-center text-center overflow-hidden z-10 bg-[#0D0D0D]">
      
      {/* Massive Ambient Background Radial Glows */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full max-w-6xl h-[550px] bg-gradient-to-r from-[#FF4D67]/25 via-[#A78BFA]/20 to-[#7C3AED]/25 rounded-full blur-[180px] pointer-events-none" />

      {/* Hero Content Container */}
      <div className="max-w-7xl mx-auto flex flex-col items-center justify-center space-y-10">

        {/* MASSIVE VYNK LOGO GRAPHIC HERO */}
        <motion.div 
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.9, ease: [0.16, 1, 0.3, 1] }}
          className="w-full flex justify-center py-4 group"
        >
          <img 
            src="/vynk_wordmark_transparent.png" 
            alt="VYNK Logo" 
            className="w-full max-w-5xl h-auto max-h-[380px] sm:max-h-[480px] object-contain drop-shadow-[0_0_60px_rgba(255,77,103,0.5)] hover:scale-[1.02] transition-transform duration-700 ease-out"
          />
        </motion.div>

        {/* Main Headline & Supporting Copy */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="space-y-6 max-w-3xl mx-auto"
        >
          <h1 className="text-3xl sm:text-5xl lg:text-6xl font-black text-white tracking-tight uppercase leading-tight font-sans">
            FIND SOMEONE WHO <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">JUST GETS YOU.</span>
          </h1>

          <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed max-w-2xl mx-auto">
            Vynk matches you beyond the swipe — using personality, interests, and compatibility to help you find connections that actually click.
          </p>

          {/* Primary CTAs */}
          <div className="pt-4 space-y-6 flex flex-col items-center">
            <div className="flex flex-wrap items-center justify-center gap-4 w-full">
              <button
                onClick={scrollToWaitlist}
                className="px-7 py-3.5 sm:px-8 sm:py-4 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] hover:from-[#FF3352] hover:to-[#6D28D9] text-white font-black text-xs sm:text-sm tracking-wider uppercase transition-all duration-300 shadow-xl shadow-[#FF4D67]/30 hover:scale-105 active:scale-95 shrink-0 flex items-center justify-center gap-2 cursor-pointer whitespace-nowrap"
              >
                <span>JOIN THE WAITLIST</span>
                <ArrowRight className="w-4 h-4 text-white" />
              </button>

              <button
                onClick={scrollToExplore}
                className="px-7 py-3.5 sm:px-8 sm:py-4 rounded-full bg-[#16162A]/90 hover:bg-[#1A1A2E] border border-white/20 hover:border-white/40 text-gray-200 hover:text-white font-black text-xs sm:text-sm tracking-wider uppercase transition-all duration-300 shadow-xl hover:scale-105 active:scale-95 shrink-0 flex items-center justify-center gap-2 cursor-pointer whitespace-nowrap"
              >
                <span>SEE WHAT’S COMING</span>
                <ArrowDown className="w-4 h-4 text-[#FF4D67] animate-bounce" />
              </button>
            </div>

            {/* iOS App Store & Google Play Store Badges */}
            <div className="pt-2">
              <AppStoreBadges scrollToWaitlist={scrollToWaitlist} />
            </div>

            {/* Small Supporting Tag */}
            <p className="text-xs font-semibold tracking-wider text-gray-400 uppercase flex items-center gap-2 pt-1">
              <span>Launching soon</span>
              <span className="text-gray-600">•</span>
              <span>Built for genuine connection</span>
            </p>
          </div>

          {/* Brand Tagline Divider */}
          <div className="pt-10 w-full border-t border-white/10 flex items-center justify-between text-xs sm:text-sm font-extrabold text-gray-400 tracking-[0.2em] uppercase">
            <span>PEOPLE</span>
            <span className="text-[#FF4D67]">×</span>
            <span>PERSONALITY</span>
            <span className="text-[#7C3AED]">×</span>
            <span>POSSIBILITY</span>
          </div>
        </motion.div>

      </div>

    </section>
  );
}
