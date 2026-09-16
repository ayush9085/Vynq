import React from 'react';
import { motion } from 'framer-motion';

export default function CampusCulture() {
  const campusVibes = [
    {
      title: "Lecture halls.",
      image: "https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=800&auto=format&fit=crop",
      sub: "Making eye contact across row 4."
    },
    {
      title: "Late-night chai.",
      image: "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=800&auto=format&fit=crop",
      sub: "Post-study debriefs at 1 AM."
    },
    {
      title: "Library crushes.",
      image: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=800&auto=format&fit=crop",
      sub: "Pretending to look for a book."
    },
    {
      title: "People you keep accidentally running into.",
      image: "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?q=80&w=800&auto=format&fit=crop",
      sub: "Third time today at the campus courtyard."
    }
  ];

  return (
    <section id="campus-culture" className="py-24 px-6 max-w-7xl mx-auto space-y-16 z-10 relative">
      
      {/* Editorial Header */}
      <div className="space-y-4 text-left max-w-3xl">
        <span className="text-xs font-bold tracking-widest text-[#FF4D67] uppercase">
          05 / BUILT FOR COLLEGE LIFE
        </span>
        <h2 className="text-4xl sm:text-6xl font-black tracking-tight text-white uppercase leading-[0.95]">
          CAMPUS IS FULL OF PEOPLE <br />
          <span className="text-[#FF4D67]">YOU HAVEN'T MET YET.</span>
        </h2>
      </div>

      {/* Photography Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {campusVibes.map((item, idx) => (
          <motion.div 
            key={idx}
            initial={{ opacity: 0, y: 25 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: idx * 0.1 }}
            className="group relative rounded-3xl overflow-hidden border border-white/10 aspect-[3/4] bg-[#121212]"
          >
            <img 
              src={item.image} 
              alt={item.title} 
              className="w-full h-full object-cover grayscale group-hover:grayscale-0 transition-all duration-700 ease-out scale-100 group-hover:scale-105"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent" />
            
            <div className="absolute bottom-6 left-6 right-6 space-y-1">
              <h3 className="text-2xl font-black text-white uppercase tracking-tight leading-tight">
                {item.title}
              </h3>
              <p className="text-xs text-gray-300 font-medium">
                {item.sub}
              </p>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Editorial Finale Statement */}
      <motion.div 
        initial={{ opacity: 0, scale: 0.98 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="bg-[#FF4D67] text-white p-12 sm:p-16 rounded-3xl text-center space-y-4 shadow-2xl shadow-[#FF4D67]/20"
      >
        <p className="text-xs font-black tracking-widest uppercase opacity-80">
          THE REAL COLLEGE DATING BRAND
        </p>
        <h3 className="text-5xl sm:text-7xl font-black tracking-tighter uppercase leading-none">
          THAT'S VYNK.
        </h3>
      </motion.div>

    </section>
  );
}
