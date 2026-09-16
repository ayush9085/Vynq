import React from 'react';
import { motion } from 'framer-motion';
import { MapPin, Coffee, Headphones, Compass, Laptop, MessageCircle, Star } from 'lucide-react';

export default function CampusSection() {
  const elements = [
    { icon: MapPin, label: "Favorite Spots", color: "#FF4D67" },
    { icon: Coffee, label: "Coffee Dates", color: "#7C3AED" },
    { icon: Headphones, label: "Live Concerts", color: "#3B82F6" },
    { icon: Compass, label: "City Discovery", color: "#FFD700" },
    { icon: Laptop, label: "Shared Passions", color: "#FF4D67" },
    { icon: MessageCircle, label: "Late-Night Banter", color: "#7C3AED" },
    { icon: Star, label: "Real Connections", color: "#FFD700" },
  ];

  return (
    <section className="py-24 px-6 max-w-7xl mx-auto space-y-16 z-10 relative overflow-hidden">
      
      {/* Background Soft Glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-gradient-to-r from-[#FF4D67]/10 via-[#7C3AED]/10 to-transparent rounded-full blur-[160px] pointer-events-none" />

      {/* Section Header */}
      <div className="text-center max-w-3xl mx-auto space-y-4">
        <span className="text-xs font-extrabold tracking-widest uppercase text-[#FF4D67] bg-[#FF4D67]/10 px-4 py-1.5 rounded-full border border-[#FF4D67]/20 inline-block">
          REAL-WORLD CONNECTIVITY
        </span>
        <h2 className="text-4xl sm:text-6xl font-black text-white tracking-tight leading-tight">
          Made for the people <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#7C3AED]">you actually click with.</span>
        </h2>
        <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed">
          From coffee dates to live concerts and quiet evening talks, Vynk is built for genuine human connection.
        </p>
      </div>

      {/* Abstract Glass UI Vector Elements Showcase */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-7 gap-4 max-w-6xl mx-auto">
        {elements.map((item, idx) => {
          const Icon = item.icon;
          return (
            <motion.div
              key={idx}
              initial={{ opacity: 0, scale: 0.9 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: idx * 0.1 }}
              whileHover={{ y: -6, scale: 1.05 }}
              className="bg-[#16162A]/90 backdrop-blur-xl border border-white/10 rounded-2xl p-6 flex flex-col items-center text-center space-y-3 shadow-xl hover:border-[#FF4D67]/40 transition-all cursor-pointer group"
            >
              <div 
                className="w-12 h-12 rounded-2xl flex items-center justify-center text-white shadow-lg transition-transform group-hover:scale-110"
                style={{ backgroundColor: `${item.color}20`, border: `1px solid ${item.color}40` }}
              >
                <Icon className="w-6 h-6" style={{ color: item.color }} />
              </div>
              <span className="text-xs font-extrabold text-white tracking-wide uppercase">
                {item.label}
              </span>
            </motion.div>
          );
        })}
      </div>

      {/* Abstract Graphic Banner */}
      <div className="max-w-4xl mx-auto bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] rounded-3xl p-10 text-center text-white space-y-2 shadow-2xl shadow-[#FF4D67]/20">
        <p className="text-xs font-black tracking-widest uppercase opacity-90">
          PERSONALITY-FIRST DATING
        </p>
        <h3 className="text-3xl sm:text-5xl font-black uppercase tracking-tight">
          THAT'S VYNK.
        </h3>
      </div>

    </section>
  );
}
