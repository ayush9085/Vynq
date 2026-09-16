import React from 'react';
import { motion } from 'framer-motion';
import { Heart, Sparkles, MessageSquare, Zap, ShieldCheck } from 'lucide-react';

export default function PhoneMockup() {
  return (
    <div className="relative w-full max-w-[340px] sm:max-w-[380px] mx-auto">
      
      {/* Ambient Micro Glow Background */}
      <div className="absolute -inset-6 bg-gradient-to-r from-[#FF4D67]/25 to-[#7C3AED]/25 rounded-[60px] blur-3xl opacity-70 pointer-events-none" />

      {/* Floating Glass Chip 1 (Top Right): 94% MATCH */}
      <motion.div
        initial={{ y: 0 }}
        animate={{ y: [-6, 6, -6] }}
        transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
        className="absolute -top-6 -right-4 sm:-right-8 z-30 px-4 py-2 rounded-2xl bg-[#16162A]/90 border border-white/20 shadow-2xl backdrop-blur-md flex items-center gap-2"
      >
        <div className="w-6 h-6 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] flex items-center justify-center text-white text-[10px] font-black">
          94%
        </div>
        <span className="text-xs font-black text-white tracking-wider">94% MATCH</span>
      </motion.div>

      {/* Floating Glass Chip 2 (Middle Left): ENFP × INFJ */}
      <motion.div
        initial={{ y: 0 }}
        animate={{ y: [6, -6, 6] }}
        transition={{ duration: 5, repeat: Infinity, ease: "easeInOut", delay: 0.5 }}
        className="absolute top-1/4 -left-6 sm:-left-10 z-30 px-4 py-2 rounded-2xl bg-[#16162A]/90 border border-white/20 shadow-2xl backdrop-blur-md flex items-center gap-2"
      >
        <span className="px-2 py-0.5 rounded bg-[#7C3AED]/30 text-[#A78BFA] text-xs font-black border border-[#7C3AED]/50">
          ENFP × INFJ
        </span>
      </motion.div>

      {/* Floating Glass Chip 3 (Bottom Right): 3 shared interests */}
      <motion.div
        initial={{ y: 0 }}
        animate={{ y: [-5, 5, -5] }}
        transition={{ duration: 4.5, repeat: Infinity, ease: "easeInOut", delay: 1 }}
        className="absolute bottom-28 -right-4 sm:-right-8 z-30 px-3.5 py-2 rounded-2xl bg-[#16162A]/90 border border-white/20 shadow-2xl backdrop-blur-md flex items-center gap-2"
      >
        <span className="text-xs font-bold text-gray-200">✨ 3 shared interests</span>
      </motion.div>

      {/* Floating Glass Chip 4 (Bottom Left): AI Icebreaker ready */}
      <motion.div
        initial={{ y: 0 }}
        animate={{ y: [4, -4, 4] }}
        transition={{ duration: 5.5, repeat: Infinity, ease: "easeInOut", delay: 1.5 }}
        className="absolute bottom-6 -left-4 sm:-left-6 z-30 px-3.5 py-2 rounded-2xl bg-[#16162A]/90 border border-white/20 shadow-2xl backdrop-blur-md flex items-center gap-2"
      >
        <Sparkles className="w-3.5 h-3.5 text-[#FF4D67]" />
        <span className="text-xs font-bold text-white">AI Icebreaker ready</span>
      </motion.div>

      {/* Smartphone Hardware Frame */}
      <div className="relative rounded-[44px] p-3.5 bg-gradient-to-b from-gray-700 via-gray-900 to-black border border-white/20 shadow-2xl overflow-hidden">
        
        {/* Dynamic Notch */}
        <div className="absolute top-4 left-1/2 -translate-x-1/2 w-28 h-4 bg-black rounded-full z-40" />

        {/* Screen Inner Container */}
        <div className="relative rounded-[34px] bg-[#0D0D0D] border border-white/10 pt-7 pb-4 px-3 flex flex-col justify-between min-h-[520px]">
          
          {/* Mock Header Bar */}
          <div className="flex items-center justify-between px-2 pb-3 border-b border-white/10 text-xs">
            <span className="font-black tracking-wider text-white uppercase text-[11px]">VYNK MATCH</span>
            <span className="px-2.5 py-0.5 rounded-full bg-[#FF4D67]/20 text-[#FF4D67] font-black text-[10px] border border-[#FF4D67]/40">
              94% Compatible
            </span>
          </div>

          {/* Profile Card Preview */}
          <div className="relative my-2 rounded-2xl overflow-hidden bg-[#16162A] border border-white/10 shadow-xl flex flex-col">
            
            {/* Image Box */}
            <div className="relative h-60 overflow-hidden">
              <img 
                src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80"
                alt="Aanya"
                className="w-full h-full object-cover"
              />
              
              {/* Badges Overlay */}
              <div className="absolute top-3 left-3 right-3 flex items-center justify-between">
                <span className="px-2.5 py-1 rounded-full bg-[#7C3AED] text-white font-black text-[10px] tracking-wider uppercase border border-white/20">
                  ENFP
                </span>
                
                {/* Circular Compatibility Indicator 94% */}
                <div className="w-9 h-9 rounded-full bg-black/80 backdrop-blur-md border border-[#FF4D67] flex items-center justify-center text-white font-black text-[10px] shadow-lg">
                  94%
                </div>
              </div>

              {/* Bottom Gradient Overlay */}
              <div className="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-[#16162A] via-[#16162A]/60 to-transparent" />
              
              <div className="absolute bottom-2 left-3">
                <h3 className="text-xl font-black text-white flex items-center gap-1.5">
                  Aanya, 19
                  <ShieldCheck className="w-4 h-4 text-[#3B82F6]" />
                </h3>
              </div>
            </div>

            {/* Profile Content */}
            <div className="p-3.5 space-y-3">
              {/* Shared Interests */}
              <div className="flex flex-wrap gap-1.5">
                <span className="px-2.5 py-1 rounded-md bg-[#1A1A2E] border border-[#252542] text-[11px] font-semibold text-gray-200">
                  🎧 Music
                </span>
                <span className="px-2.5 py-1 rounded-md bg-[#1A1A2E] border border-[#252542] text-[11px] font-semibold text-gray-200">
                  🎬 Movies
                </span>
                <span className="px-2.5 py-1 rounded-md bg-[#1A1A2E] border border-[#252542] text-[11px] font-semibold text-gray-200">
                  ☕ Cafés
                </span>
                <span className="px-2.5 py-1 rounded-md bg-[#1A1A2E] border border-[#252542] text-[11px] font-semibold text-gray-200">
                  ✈️ Travel
                </span>
              </div>

              {/* Copy note */}
              <div className="p-2.5 rounded-xl bg-[#1A1A2E] border border-[#252542] text-center">
                <p className="text-xs font-bold text-[#FF4D67]">
                  “You two might actually click.”
                </p>
              </div>
            </div>

          </div>

          {/* Action Buttons Mockup */}
          <div className="mt-2 flex items-center justify-center gap-4">
            <div className="w-10 h-10 rounded-full bg-[#1A1A2E] border border-[#252542] flex items-center justify-center text-gray-400">
              ✕
            </div>
            <div className="w-12 h-12 rounded-full bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] flex items-center justify-center text-white shadow-lg shadow-[#FF4D67]/30">
              <Heart className="w-6 h-6 fill-white" />
            </div>
            <div className="w-10 h-10 rounded-full bg-[#3B82F6]/20 border border-[#3B82F6]/40 flex items-center justify-center text-[#3B82F6]">
              <Sparkles className="w-4 h-4" />
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
