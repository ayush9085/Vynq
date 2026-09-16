import React from 'react';
import { motion } from 'framer-motion';

export default function SwipeLessSection() {
  const cards = [
    {
      emoji: "🧠",
      title: "PERSONALITY FIRST",
      desc: "Discover compatibility through personality, not just profile pictures.",
      glowColor: "from-[#FF4D67]/20 to-[#FF4D67]/5"
    },
    {
      emoji: "💬",
      title: "NEVER START WITH “HEY”",
      desc: "AI-powered icebreakers built around your personality and shared interests.",
      glowColor: "from-[#7C3AED]/20 to-[#7C3AED]/5"
    },
    {
      emoji: "⚡",
      title: "BUILT FOR REAL LIFE",
      desc: "Designed around real-world dynamics, shared passions, and genuine human chemistry.",
      glowColor: "from-[#3B82F6]/20 to-[#3B82F6]/5"
    }
  ];

  return (
    <section id="how-it-works" className="py-24 px-6 max-w-7xl mx-auto space-y-16 z-10 relative">
      
      {/* Centered Header */}
      <div className="text-center max-w-3xl mx-auto space-y-4">
        <h2 className="text-4xl sm:text-6xl font-black text-white tracking-tight leading-tight">
          Swipe less. <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">Connect better.</span>
        </h2>
        <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed">
          Looks might get your attention. Personality keeps the conversation going.
        </p>
      </div>

      {/* 3 Glassmorphism Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        {cards.map((card, idx) => (
          <motion.div
            key={idx}
            initial={{ opacity: 0, y: 25 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: idx * 0.15 }}
            whileHover={{ y: -5 }}
            className="group relative bg-[#16162A]/90 backdrop-blur-xl border border-white/10 hover:border-[#FF4D67]/40 rounded-3xl p-8 space-y-6 transition-all duration-300 shadow-xl flex flex-col justify-between"
          >
            {/* Ambient Card Glow Behind Icon */}
            <div className={`absolute top-6 left-6 w-16 h-16 bg-gradient-to-br ${card.glowColor} rounded-2xl blur-xl group-hover:scale-125 transition-transform duration-300 pointer-events-none`} />

            <div className="space-y-4 relative z-10">
              {/* Emoji Icon Badge */}
              <div className="w-14 h-14 rounded-2xl bg-[#1A1A2E] border border-white/10 flex items-center justify-center text-3xl shadow-inner">
                {card.emoji}
              </div>

              {/* Title */}
              <h3 className="text-xl sm:text-2xl font-black text-white tracking-tight uppercase">
                {card.title}
              </h3>

              {/* Description */}
              <p className="text-sm text-gray-300 font-medium leading-relaxed">
                {card.desc}
              </p>
            </div>

            <div className="pt-4 border-t border-white/5 flex items-center text-xs text-gray-400 font-bold uppercase tracking-widest group-hover:text-[#FF4D67] transition-colors">
              <span>EXPLORE FEATURE →</span>
            </div>
          </motion.div>
        ))}
      </div>

    </section>
  );
}
