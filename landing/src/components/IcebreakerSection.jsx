import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Sparkles, MessageSquare, Check } from 'lucide-react';

export default function IcebreakerSection() {
  const [copiedIdx, setCopiedIdx] = useState(null);

  const suggestions = [
    "Okay, important question — what's the one Weeknd song you never skip?",
    "Coffee person or chai person? This could determine everything.",
    "Your personality says you're spontaneous. Prove it."
  ];

  const handleCopy = (idx) => {
    setCopiedIdx(idx);
    setTimeout(() => setCopiedIdx(null), 2000);
  };

  return (
    <section id="icebreakers" className="py-24 px-6 max-w-7xl mx-auto space-y-16 z-10 relative">
      
      {/* Section Header */}
      <div className="text-center max-w-3xl mx-auto space-y-4">
        <h2 className="text-4xl sm:text-6xl font-black text-white tracking-tight leading-tight">
          Good matches deserve <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">better opening lines.</span>
        </h2>
        <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed">
          Vynk's AI creates conversation starters based on your personality and what you have in common.
        </p>
      </div>

      {/* Dark Chat Style Visual Container */}
      <div className="max-w-3xl mx-auto bg-[#16162A]/90 border border-white/10 rounded-3xl p-8 sm:p-12 space-y-8 shadow-2xl backdrop-blur-xl">
        
        {/* Profile Bar Header */}
        <div className="flex items-center justify-between border-b border-white/10 pb-6">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-full overflow-hidden border border-white/20">
              <img 
                src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80" 
                alt="Aanya" 
                className="w-full h-full object-cover"
              />
            </div>
            <div>
              <h3 className="text-lg font-black text-white flex items-center gap-2">
                Aanya
                <span className="px-2 py-0.5 rounded bg-[#7C3AED]/30 text-[#A78BFA] font-bold text-xs">
                  ENFP
                </span>
              </h3>
              <p className="text-xs font-bold text-[#FF4D67]">94% Compatible Match</p>
            </div>
          </div>

          <span className="px-3 py-1 rounded-full bg-white/5 border border-white/10 text-xs font-bold text-gray-300">
            ACTIVE MATCH
          </span>
        </div>

        {/* Shared Interest Chips */}
        <div className="space-y-2">
          <span className="text-[11px] font-extrabold tracking-widest uppercase text-gray-400">
            SHARED INTERESTS:
          </span>
          <div className="flex flex-wrap gap-2">
            <span className="px-3.5 py-1.5 rounded-full bg-[#1A1A2E] border border-white/10 text-xs font-bold text-gray-200">
              🎧 The Weeknd
            </span>
            <span className="px-3.5 py-1.5 rounded-full bg-[#1A1A2E] border border-white/10 text-xs font-bold text-gray-200">
              ☕ Coffee
            </span>
            <span className="px-3.5 py-1.5 rounded-full bg-[#1A1A2E] border border-white/10 text-xs font-bold text-gray-200">
              🎬 Marvel
            </span>
          </div>
        </div>

        {/* AI Icebreaker Suggestions */}
        <div className="space-y-4">
          <div className="flex items-center gap-2 text-xs font-black tracking-widest text-[#FF4D67] uppercase">
            <Sparkles className="w-4 h-4 text-[#FF4D67]" />
            <span>AI ICEBREAKER SUGGESTIONS</span>
          </div>

          <div className="space-y-3">
            {suggestions.map((text, idx) => (
              <motion.button
                key={idx}
                onClick={() => handleCopy(idx)}
                whileHover={{ scale: 1.01 }}
                whileTap={{ scale: 0.99 }}
                className="w-full text-left p-5 rounded-2xl bg-[#1A1A2E] border border-white/10 hover:border-[#FF4D67]/50 transition-all flex items-center justify-between group cursor-pointer"
              >
                <span className="text-sm font-bold text-white leading-relaxed pr-4">
                  “{text}”
                </span>
                <span className="px-3 py-1.5 rounded-full bg-[#FF4D67]/10 text-[#FF4D67] text-xs font-bold shrink-0 flex items-center gap-1 group-hover:bg-[#FF4D67] group-hover:text-white transition-colors">
                  {copiedIdx === idx ? <Check className="w-3.5 h-3.5" /> : <MessageSquare className="w-3.5 h-3.5" />}
                  <span>{copiedIdx === idx ? 'COPIED' : 'TAP TO USE'}</span>
                </span>
              </motion.button>
            ))}
          </div>
        </div>

      </div>

    </section>
  );
}
