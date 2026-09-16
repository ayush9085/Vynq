import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import SwipeLessSection from './components/SwipeLessSection';
import MBTIConstellation from './components/MBTIConstellation';
import IcebreakerSection from './components/IcebreakerSection';
import CampusSection from './components/CampusSection';
import WaitlistSection from './components/WaitlistSection';
import Footer from './components/Footer';
import { PrivacyModal, TermsModal, ContactModal } from './components/LegalModals';

export default function App() {
  const [privacyOpen, setPrivacyOpen] = useState(false);
  const [termsOpen, setTermsOpen] = useState(false);
  const [contactOpen, setContactOpen] = useState(false);

  return (
    <div className="min-h-screen bg-[#0D0D0D] text-white selection:bg-[#FF4D67] selection:text-white relative overflow-hidden font-sans">
      
      {/* Floating Glass Navbar */}
      <Navbar />

      {/* Main Product Launch & Teaser Sections */}
      <main className="space-y-12 sm:space-y-20">
        {/* BIG VYNK LOGO HERO SECTION */}
        <Hero />

        {/* "Swipe less. Connect better." (3 Cards) */}
        <SwipeLessSection />

        {/* MBTI 16x16 Constellation */}
        <MBTIConstellation />

        {/* AI Icebreaker Fake Conversation UI */}
        <IcebreakerSection />

        {/* Real-World Connectivity & Culture */}
        <CampusSection />

        {/* High-Impact Waitlist CTA */}
        <WaitlistSection />
      </main>

      {/* Minimal Footer */}
      <Footer 
        onOpenPrivacy={() => setPrivacyOpen(true)}
        onOpenTerms={() => setTermsOpen(true)}
        onOpenContact={() => setContactOpen(true)}
      />

      {/* Interactive Modals */}
      <PrivacyModal isOpen={privacyOpen} onClose={() => setPrivacyOpen(false)} />
      <TermsModal isOpen={termsOpen} onClose={() => setTermsOpen(false)} />
      <ContactModal isOpen={contactOpen} onClose={() => setContactOpen(false)} />

    </div>
  );
}
