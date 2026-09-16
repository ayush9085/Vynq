import React, { useState } from 'react';
import { motion } from 'framer-motion';

const mbtiGrid = [
  // Row 1: Analysts
  [
    { type: 'INTJ', category: 'Analyst', match: '96%', pairedWith: 'ENFP' },
    { type: 'INTP', category: 'Analyst', match: '92%', pairedWith: 'ENTJ' },
    { type: 'ENTJ', category: 'Analyst', match: '94%', pairedWith: 'INTP' },
    { type: 'ENTP', category: 'Analyst', match: '91%', pairedWith: 'INTJ' },
  ],
  // Row 2: Diplomats
  [
    { type: 'INFJ', category: 'Diplomat', match: '94%', pairedWith: 'ENFP' },
    { type: 'INFP', category: 'Diplomat', match: '96%', pairedWith: 'ENFJ' },
    { type: 'ENFJ', category: 'Diplomat', match: '95%', pairedWith: 'INFP' },
    { type: 'ENFP', category: 'Diplomat', match: '94%', pairedWith: 'INFJ' },
  ],
  // Row 3: Sentinels
  [
    { type: 'ISTJ', category: 'Sentinel', match: '88%', pairedWith: 'ESTP' },
    { type: 'ISFJ', category: 'Sentinel', match: '89%', pairedWith: 'ESFP' },
    { type: 'ESTJ', category: 'Sentinel', match: '90%', pairedWith: 'ISTP' },
    { type: 'ESFJ', category: 'Sentinel', match: '92%', pairedWith: 'ISFP' },
  ],
  // Row 4: Explorers
  [
    { type: 'ISTP', category: 'Explorer', match: '91%', pairedWith: 'ESTJ' },
    { type: 'ISFP', category: 'Explorer', match: '93%', pairedWith: 'ESFJ' },
    { type: 'ESTP', category: 'Explorer', match: '89%', pairedWith: 'ISTJ' },
    { type: 'ESFP', category: 'Explorer', match: '90%', pairedWith: 'ISFJ' },
  ]
];

export default function MBTIConstellation() {
  const [activeType, setActiveType] = useState(mbtiGrid[1][3]); // ENFP default

  return (
    <section id="compatibility" className="py-24 px-6 max-w-7xl mx-auto space-y-16 z-10 relative overflow-hidden">
      
      {/* Background Micro Glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] bg-gradient-to-r from-[#FF4D67]/10 via-[#7C3AED]/10 to-transparent rounded-full blur-[160px] pointer-events-none" />

      {/* Section Header */}
      <div className="text-center max-w-3xl mx-auto space-y-4">
        <span className="text-xs font-extrabold tracking-widest uppercase text-[#FF4D67] bg-[#FF4D67]/10 px-4 py-1.5 rounded-full border border-[#FF4D67]/20 inline-block">
          16 TYPES. INFINITE CONNECTIONS.
        </span>
        <h2 className="text-4xl sm:text-6xl font-black text-white tracking-tight leading-tight">
          Your type says <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">more than you think.</span>
        </h2>
        <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed">
          Vynk uses personality compatibility to discover the people you naturally click with.
        </p>
      </div>

      {/* Structured 4x4 Grid Matrix Container */}
      <div className="relative bg-[#16162A]/70 border border-white/10 rounded-3xl p-8 sm:p-12 space-y-10 flex flex-col items-center justify-center shadow-2xl backdrop-blur-xl">
        
        {/* Central Orb Display */}
        <div className="w-36 h-36 rounded-full bg-gradient-to-br from-[#FF4D67] to-[#7C3AED] p-0.5 shadow-2xl shadow-[#FF4D67]/30 flex items-center justify-center text-center">
          <div className="w-full h-full rounded-full bg-[#0D0D0D] flex flex-col items-center justify-center p-4">
            <span className="text-3xl font-black text-white tracking-tighter uppercase font-sans">
              16 × 16
            </span>
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-0.5">
              PERSONALITY MATRIX
            </span>
          </div>
        </div>

        {/* 4x4 Grid Matrix UI */}
        <div className="w-full max-w-2xl space-y-3 sm:space-y-4">
          {mbtiGrid.map((row, rIdx) => (
            <div key={rIdx} className="grid grid-cols-4 gap-3 sm:gap-4">
              {row.map((item) => {
                const isActive = activeType.type === item.type;
                return (
                  <motion.button
                    key={item.type}
                    onClick={() => setActiveType(item)}
                    onMouseEnter={() => setActiveType(item)}
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                    className={`py-3 px-2 sm:px-4 rounded-xl text-xs sm:text-sm font-black tracking-wider transition-all duration-300 cursor-pointer text-center shadow-lg ${
                      isActive 
                        ? 'bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] text-white border-2 border-white scale-105 shadow-[#FF4D67]/40 ring-4 ring-[#FF4D67]/20' 
                        : 'bg-[#1A1A2E] border border-white/10 text-gray-300 hover:border-[#FF4D67]/50 hover:text-white'
                    }`}
                  >
                    {item.type}
                  </motion.button>
                );
              })}
            </div>
          ))}
        </div>

        {/* Interactive Compatibility Tooltip Card (Bottom) */}
        <div className="w-full max-w-md px-6 py-4 rounded-2xl bg-[#0D0D0D]/95 border border-[#FF4D67]/40 shadow-2xl text-center flex items-center justify-around animate-in fade-in duration-200">
          <div>
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block">SELECTED TYPE</span>
            <span className="text-xl font-black text-white">{activeType.type}</span>
            <span className="text-[10px] font-semibold text-gray-500 block">{activeType.category}</span>
          </div>
          <div className="w-px h-10 bg-white/10" />
          <div>
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block">BEST MATCH</span>
            <span className="text-xl font-black text-[#FF4D67]">{activeType.pairedWith} ({activeType.match})</span>
            <span className="text-[10px] font-semibold text-[#A78BFA] block">High Synergy</span>
          </div>
        </div>

      </div>

    </section>
  );
}
