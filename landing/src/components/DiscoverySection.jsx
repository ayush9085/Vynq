import React from 'react';
import { motion } from 'framer-motion';

export default function DiscoverySection() {
  const discoveryMoments = [
    {
      title: "Your City & Beyond.",
      image: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=800&auto=format&fit=crop",
      sub: "Concerts, nightlife, and live music."
    },
    {
      title: "Coffee & Conversation.",
      image: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=800&auto=format&fit=crop",
      sub: "Casual afternoon meetings that run long."
    },
    {
      title: "Campus & Creative Spots.",
      image: "https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=800&auto=format&fit=crop",
      sub: "Study breaks, libraries, and courtyard chats."
    },
    {
      title: "Everyday Connections.",
      image: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=800&auto=format&fit=crop",
      sub: "People who share your wavelength."
    }
  ];

  return (
    <section id="discovery" className="py-24 px-6 max-w-7xl mx-auto space-y-16 z-10 relative">
      
      {/* Editorial Header */}
      <div className="space-y-4 text-left max-w-4xl">
        <span className="text-xs font-bold tracking-widest text-[#FF4D67] uppercase">
          04 / DISCOVERY & PEOPLE
        </span>
        <h2 className="text-4xl sm:text-6xl font-black tracking-tight text-white uppercase leading-[0.95]">
          WHETHER IT'S SOMEONE FROM YOUR CAMPUS, YOUR CITY, <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#A78BFA]">OR SOMEWHERE UNEXPECTED...</span>
        </h2>
        <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed">
          Vynk helps you discover people you click with — wherever you are.
        </p>
      </div>

      {/* Broad Photography Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {discoveryMoments.map((item, idx) => (
          <motion.div 
            key={idx}
            initial={{ opacity: 0, y: 25 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: idx * 0.1 }}
            className="group relative rounded-3xl overflow-hidden border border-[#252542] aspect-[3/4] bg-[#16162A]"
          >
            <img 
              src={item.image} 
              alt={item.title} 
              className="w-full h-full object-cover group-hover:scale-105 transition-all duration-700 ease-out"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-[#0D0D0D]/90 via-[#0D0D0D]/30 to-transparent" />
            
            <div className="absolute bottom-6 left-6 right-6 space-y-1">
              <h3 className="text-xl font-black text-white uppercase tracking-tight leading-tight">
                {item.title}
              </h3>
              <p className="text-xs text-gray-300 font-medium">
                {item.sub}
              </p>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Brand Statement Banner */}
      <motion.div 
        initial={{ opacity: 0, scale: 0.98 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="bg-gradient-to-r from-[#FF4D67] to-[#7C3AED] text-white p-10 sm:p-14 rounded-3xl text-center space-y-3 shadow-2xl shadow-[#FF4D67]/20"
      >
        <p className="text-xs font-black tracking-widest uppercase opacity-90">
          PERSONALITY-FIRST DATING
        </p>
        <h3 className="text-4xl sm:text-6xl font-black tracking-tighter uppercase leading-none">
          MORE THAN A MATCH.
        </h3>
      </motion.div>

    </section>
  );
}
