import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { MapPin, Users, Sparkles, CheckCircle2 } from 'lucide-react';

const campuses = [
  { name: 'NYU', location: 'New York, NY', signups: 412, status: '92% Full', topType: 'ENFP', badge: 'HIGH DEMAND' },
  { name: 'Columbia', location: 'New York, NY', signups: 348, status: '88% Full', topType: 'INTJ', badge: 'SPOT SAVED' },
  { name: 'Delhi University (DU)', location: 'Delhi, IN', signups: 620, status: '96% Full', topType: 'ENFJ', badge: 'VERY ACTIVE' },
  { name: 'IIT Bombay', location: 'Mumbai, IN', signups: 540, status: '94% Full', topType: 'INTP', badge: 'HIGH DEMAND' },
  { name: 'UCLA', location: 'Los Angeles, CA', signups: 395, status: '89% Full', topType: 'ESFP', badge: 'POPULAR' },
  { name: 'Stanford', location: 'Palo Alto, CA', signups: 310, status: '85% Full', topType: 'ENTJ', badge: 'ACTIVE' },
  { name: 'UC Berkeley', location: 'Berkeley, CA', signups: 425, status: '91% Full', topType: 'INFJ', badge: 'HIGH DEMAND' },
  { name: 'Oxford', location: 'Oxford, UK', signups: 285, status: '82% Full', topType: 'INFP', badge: 'OPENING SOON' },
];

export default function CampusPulse() {
  const [selectedCampus, setSelectedCampus] = useState(campuses[0]);

  return (
    <section className="relative py-20 px-4 sm:px-6 max-w-6xl mx-auto z-10">
      <div className="glass-card rounded-3xl p-6 sm:p-10 border border-white/10 bg-gradient-to-r from-[#12121C]/90 via-[#0D0D14]/90 to-[#070709]/90 shadow-2xl">
        
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 pb-8 border-b border-white/10">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#F43F5E]/10 border border-[#F43F5E]/20 text-[#FB7185] text-xs font-bold uppercase tracking-widest mb-3">
              <Sparkles className="w-3.5 h-3.5 text-[#FFD700]" />
              LIVE CAMPUS RADAR
            </div>
            <h3 className="text-2xl sm:text-4xl font-extrabold text-white tracking-tight">
              Checking waitlist queues by campus.
            </h3>
            <p className="text-sm text-gray-300 mt-1 max-w-xl">
              Vynk launches campus-by-campus once a university pool reaches 500 verified student signups.
            </p>
          </div>

          <div className="flex items-center gap-3 bg-white/5 px-4 py-2.5 rounded-2xl border border-white/10 shrink-0">
            <Users className="w-4 h-4 text-[#F43F5E]" />
            <span className="text-xs font-bold text-gray-200">
              <strong className="text-white">3,335+</strong> total campus signups
            </span>
          </div>
        </div>

        {/* Campus Selection Pills */}
        <div className="pt-6 space-y-4">
          <p className="text-xs font-semibold uppercase tracking-wider text-gray-400">SELECT YOUR UNIVERSITY:</p>
          <div className="flex flex-wrap gap-2.5">
            {campuses.map((c) => {
              const isSelected = selectedCampus.name === c.name;
              return (
                <button
                  key={c.name}
                  onClick={() => setSelectedCampus(c)}
                  className={`px-4 py-2 rounded-xl text-xs font-bold transition-all duration-300 flex items-center gap-2 cursor-pointer border ${
                    isSelected
                      ? 'bg-[#F43F5E] text-white border-[#F43F5E] shadow-lg shadow-[#F43F5E]/30 scale-105'
                      : 'bg-white/5 text-gray-300 border-white/10 hover:border-white/25 hover:bg-white/10'
                  }`}
                >
                  <MapPin className="w-3 h-3" />
                  <span>{c.name}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Selected Campus Live Data Card */}
        <AnimatePresence mode="wait">
          <motion.div
            key={selectedCampus.name}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            transition={{ duration: 0.3 }}
            className="mt-6 p-5 rounded-2xl glass-panel bg-white/[0.02] border border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4"
          >
            <div className="flex items-center gap-4 text-left">
              <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-[#F43F5E] to-[#7C3AED] flex items-center justify-center font-black text-white text-base shadow-md">
                {selectedCampus.name.substring(0, 2).toUpperCase()}
              </div>

              <div>
                <div className="flex items-center gap-2">
                  <h4 className="text-lg font-bold text-white">{selectedCampus.name}</h4>
                  <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-[#F43F5E]/20 text-[#FB7185] border border-[#F43F5E]/30">
                    {selectedCampus.badge}
                  </span>
                </div>
                <p className="text-xs text-gray-400 mt-0.5">{selectedCampus.location}</p>
              </div>
            </div>

            <div className="flex items-center gap-6 text-center sm:text-right">
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">WAITLIST QUEUE</p>
                <p className="text-base font-black text-white">{selectedCampus.signups} Students</p>
              </div>

              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider">TOP MBTI TRAIT</p>
                <p className="text-base font-black text-[#A78BFA]">{selectedCampus.topType}</p>
              </div>

              <div className="pl-2">
                <span className="px-3 py-1 rounded-full bg-green-500/20 text-green-400 border border-green-500/30 text-xs font-bold flex items-center gap-1.5">
                  <CheckCircle2 className="w-3.5 h-3.5" />
                  {selectedCampus.status}
                </span>
              </div>
            </div>
          </motion.div>
        </AnimatePresence>

      </div>
    </section>
  );
}
