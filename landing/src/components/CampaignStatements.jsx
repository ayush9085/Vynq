import React from 'react';
import { motion } from 'framer-motion';

export default function CampaignStatements() {
  return (
    <section id="how-it-works" className="py-24 px-6 max-w-7xl mx-auto space-y-32 z-10 relative">
      
      {/* SECTION 1: BIG STATEMENT */}
      <div className="border-t border-b border-white/10 py-20 grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
        <motion.div 
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.7 }}
          className="lg:col-span-8 space-y-6"
        >
          <span className="text-xs font-bold tracking-widest text-[#FF4D67] uppercase">
            01 / COGNITIVE CHEMISTRY
          </span>
          <h2 className="text-4xl sm:text-7xl font-black tracking-tight text-white uppercase leading-[0.95]">
            SOME PEOPLE JUST CLICK.
          </h2>
          <p className="text-2xl sm:text-4xl font-extrabold text-[#FF4D67] tracking-tight font-serif italic">
            “We want to know why.”
          </p>
        </motion.div>

        <motion.div 
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.7, delay: 0.15 }}
          className="lg:col-span-4"
        >
          <p className="text-base sm:text-lg text-gray-400 font-normal leading-relaxed">
            Standard dating apps rely on superficial 2-second visual decisions. Vynk reverse-engineers cognitive chemistry and personality overlap so you actually enjoy talking to your matches.
          </p>
        </motion.div>
      </div>

      {/* SECTION 2: EDITORIAL LARGE IMAGE + TEXT SPLIT */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
        
        {/* Large Editorial Lifestyle Image */}
        <motion.div 
          initial={{ opacity: 0, x: -30 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="lg:col-span-6"
        >
          <div className="rounded-3xl overflow-hidden border border-white/10 aspect-[4/5] bg-[#121212] relative group">
            <img 
              src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=1200&auto=format&fit=crop" 
              alt="Students hanging out and talking" 
              className="w-full h-full object-cover grayscale group-hover:grayscale-0 transition-all duration-700 scale-100 group-hover:scale-105"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />
            <div className="absolute bottom-6 left-6 right-6">
              <span className="text-xs font-bold text-gray-400 uppercase tracking-widest block mb-1">
                CAMPUS MOMENT
              </span>
              <p className="text-white font-bold text-lg">
                Late night study breaks & 2 AM conversations.
              </p>
            </div>
          </div>
        </motion.div>

        {/* Text Editorial Content */}
        <motion.div 
          initial={{ opacity: 0, x: 30 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8, delay: 0.1 }}
          className="lg:col-span-6 space-y-8 lg:pl-6"
        >
          <span className="text-xs font-bold tracking-widest text-[#FF4D67] uppercase">
            02 / THE REASON
          </span>

          <h3 className="text-4xl sm:text-6xl font-black tracking-tight text-white uppercase leading-[0.98]">
            LOOKS GET ATTENTION. <br />
            <span className="text-[#FF4D67]">PERSONALITY STARTS SOMETHING.</span>
          </h3>

          <p className="text-lg text-gray-300 font-normal leading-relaxed">
            Good conversations aren’t accidents. They happen when two minds naturally sync up. Vynk gives you real substance to start a conversation about before you even send the first message.
          </p>

          <div className="pt-4 grid grid-cols-2 gap-6 border-t border-white/10">
            <div>
              <p className="text-3xl sm:text-4xl font-black text-white">16</p>
              <p className="text-xs text-gray-400 font-semibold uppercase tracking-wider mt-1">
                Personality Types Evaluated
              </p>
            </div>
            <div>
              <p className="text-3xl sm:text-4xl font-black text-[#FF4D67]">4×</p>
              <p className="text-xs text-gray-400 font-semibold uppercase tracking-wider mt-1">
                Higher Match Conversation Rate
              </p>
            </div>
          </div>
        </motion.div>

      </div>

    </section>
  );
}
