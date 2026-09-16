import React from 'react';
import { motion } from 'framer-motion';

export default function BrandLogoSection() {
  return (
    <section className="py-24 sm:py-36 px-4 w-full z-10 relative overflow-hidden text-center bg-[#0D0D0D]">
      
      {/* Massive Background Glow Effect */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full max-w-6xl h-[500px] bg-gradient-to-r from-[#FF4D67]/25 via-[#A78BFA]/20 to-[#7C3AED]/25 rounded-full blur-[180px] pointer-events-none" />

      {/* Edge-to-Edge Container */}
      <div className="max-w-7xl mx-auto flex flex-col items-center justify-center space-y-12">

        {/* MASSIVE FULL-WIDTH VYNK LOGO GRAPHIC */}
        <motion.div 
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.9, ease: [0.16, 1, 0.3, 1] }}
          className="w-full flex justify-center py-6 group"
        >
          <img 
            src="/vynk_wordmark_transparent.png" 
            alt="VYNK Logo" 
            className="w-full max-w-5xl h-auto max-h-[380px] sm:max-h-[460px] object-contain drop-shadow-[0_0_60px_rgba(255,77,103,0.45)] hover:scale-[1.02] transition-transform duration-700 ease-out"
          />
        </motion.div>

        {/* Brand Tagline & Divider */}
        <motion.div 
          initial={{ opacity: 0, y: 15 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2 }}
          className="space-y-6 max-w-2xl mx-auto"
        >
          <p className="text-xl sm:text-3xl font-black text-white tracking-tight uppercase">
            FIND SOMEONE WHO <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">JUST GETS YOU.</span>
          </p>

          <div className="pt-6 w-full border-t border-white/10 flex items-center justify-between text-xs sm:text-sm font-extrabold text-gray-400 tracking-[0.2em] uppercase">
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
