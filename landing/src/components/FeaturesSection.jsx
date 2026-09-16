import React from 'react';
import { motion } from 'framer-motion';
import { Brain, Heart, MessageSquare, Compass, CheckCircle } from 'lucide-react';

export default function FeaturesSection() {
  const features = [
    {
      icon: Brain,
      category: "PERSONALITY",
      title: "Know more than their favorite photo.",
      tagline: "Looks get your attention. Personality makes you stay.",
      desc: "Vynk measures 4 core cognitive dimensions so you understand how someone thinks, communicates, and experiences life before you even send a message.",
      points: [
        "16 distinct personality types evaluated",
        "8 targeted prompts instead of empty bios",
        "Deep cognitive synergy analysis"
      ]
    },
    {
      icon: Heart,
      category: "COMPATIBILITY",
      title: "See why you click.",
      tagline: "Some people just click.",
      desc: "Our matching matrix calculates your compatibility score based on cognitive harmony, shared passions, and conversational synergy.",
      points: [
        "Explainable compatibility percentage",
        "Shared interest overlap mapping",
        "Mutual energy & communication alignment"
      ]
    },
    {
      icon: MessageSquare,
      category: "CONVERSATIONS",
      title: "Start with something better than 'hey'.",
      tagline: "Dating, but make it personal.",
      desc: "Contextual conversation starters automatically highlight what you both actually have in common — turning awkward openers into effortless 4-hour chats.",
      points: [
        "AI-assisted icebreakers from shared traits",
        "Zero generic 'hey' or 'what's up'",
        "Contextual prompts tailored to both profiles"
      ]
    },
    {
      icon: Compass,
      category: "DISCOVERY",
      title: "Meet people who make sense for you.",
      tagline: "Find your kind of person.",
      desc: "Whether you're looking for deep conversations, genuine dating, or a partner who truly understands you — Vynk surfaces quality over endless noise.",
      points: [
        "Curated daily matches",
        "100% verified authentic profiles",
        "Intentional, high-quality discovery"
      ]
    }
  ];

  return (
    <section id="features" className="py-24 px-6 max-w-7xl mx-auto space-y-20 z-10 relative">
      <div id="how-it-works" className="absolute -top-32" />

      {/* Editorial Header */}
      <div className="space-y-4 max-w-3xl text-left">
        <div className="inline-flex items-center gap-2 text-xs font-bold tracking-widest text-[#FF4D67] uppercase">
          <span className="w-2 h-2 rounded-full bg-[#FF4D67]" />
          <span>DESIGNED FOR MEANINGFUL CONNECTION</span>
        </div>
        <h2 className="text-4xl sm:text-6xl font-black tracking-tight text-white uppercase leading-[0.95]">
          LOOKS GET ATTENTION. <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#FF4D67] to-[#A78BFA]">PERSONALITY MAKES YOU STAY.</span>
        </h2>
        <p className="text-base sm:text-xl text-gray-300 font-medium leading-relaxed">
          Vynk combines cognitive compatibility, shared interests, and effortless icebreakers so every match has a reason to exist.
        </p>
      </div>

      {/* Varied Feature Cards Layout */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {features.map((item, idx) => {
          const Icon = item.icon;
          return (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 25 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: idx * 0.1 }}
              className="bg-[#16162A] border border-[#252542] hover:border-[#FF4D67]/40 rounded-3xl p-8 sm:p-10 flex flex-col justify-between space-y-6 transition-all duration-300"
            >
              <div className="space-y-4">
                {/* Header Icon & Tag */}
                <div className="flex items-center justify-between">
                  <div className="w-12 h-12 rounded-2xl bg-[#1A1A2E] border border-[#252542] flex items-center justify-center text-[#FF4D67]">
                    <Icon className="w-6 h-6" />
                  </div>
                  <span className="text-xs font-black tracking-widest text-[#FF4D67] uppercase bg-[#FF4D67]/10 px-3 py-1 rounded-full border border-[#FF4D67]/20">
                    {item.category}
                  </span>
                </div>

                {/* Title & Tagline */}
                <h3 className="text-2xl sm:text-3xl font-black text-white tracking-tight uppercase leading-tight">
                  {item.title}
                </h3>
                <p className="text-sm font-bold text-[#A78BFA]">
                  “{item.tagline}”
                </p>

                {/* Description */}
                <p className="text-sm text-gray-300 font-medium leading-relaxed">
                  {item.desc}
                </p>
              </div>

              {/* Bullet points */}
              <div className="pt-4 border-t border-[#252542] space-y-2">
                {item.points.map((pt, pIdx) => (
                  <div key={pIdx} className="flex items-center gap-2.5 text-xs text-gray-300 font-semibold">
                    <CheckCircle className="w-4 h-4 text-[#FF4D67] shrink-0" />
                    <span>{pt}</span>
                  </div>
                ))}
              </div>
            </motion.div>
          );
        })}
      </div>

    </section>
  );
}
