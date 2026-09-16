import React from 'react';

export default function AppStoreBadges({ scrollToWaitlist }) {
  return (
    <div className="flex flex-wrap items-center justify-center lg:justify-start gap-3 pt-2">
      {/* Apple App Store Badge */}
      <button
        onClick={scrollToWaitlist}
        className="group relative px-4 py-2.5 rounded-2xl glass-card border border-white/15 hover:border-[#FF4D67]/40 bg-[#16162A]/80 hover:bg-[#1A1A2E] transition-all duration-300 flex items-center gap-3 cursor-pointer shadow-lg shadow-black/40 hover:scale-[1.02]"
      >
        {/* Apple SVG Icon */}
        <svg className="w-6 h-6 fill-white group-hover:scale-110 transition-transform" viewBox="0 0 384 512">
          <path d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-91.9-61.7-91.9zM250.8 91.2c21.7-26 36.2-62.5 31.6-91.2-26.3 1.4-57.9 17.7-76.3 39.1-18.1 21-33 56.6-28.1 84.8 29.3 2.1 59.8-15.5 72.8-32.7z"/>
        </svg>
        
        <div className="text-left">
          <div className="flex items-center gap-1.5">
            <span className="text-[9px] font-bold text-[#FF7B93] uppercase tracking-widest">COMING SOON ON</span>
            <span className="w-1.5 h-1.5 rounded-full bg-[#FF4D67] animate-pulse" />
          </div>
          <p className="text-xs font-black text-white tracking-wide">App Store</p>
        </div>
      </button>

      {/* Google Play Store Badge */}
      <button
        onClick={scrollToWaitlist}
        className="group relative px-4 py-2.5 rounded-2xl glass-card border border-white/15 hover:border-[#3B82F6]/40 bg-[#16162A]/80 hover:bg-[#1A1A2E] transition-all duration-300 flex items-center gap-3 cursor-pointer shadow-lg shadow-black/40 hover:scale-[1.02]"
      >
        {/* Google Play SVG Icon */}
        <svg className="w-6 h-6 group-hover:scale-110 transition-transform" viewBox="0 0 512 512">
          <path fill="#34A853" d="M47 38.8v434.4l246.3-217.2L47 38.8z"/>
          <path fill="#FBBC04" d="M375.4 142.1L293.3 256l82.1 113.9 66.8-38.6c19-11 19-28.9 0-39.9l-66.8-89.3z"/>
          <path fill="#EA4335" d="M47 38.8l246.3 217.2L375.4 142 113.8 2c-19-11-44 3.5-66.8 36.8z"/>
          <path fill="#4285F4" d="M47 473.2l246.3-217.2L375.4 370 113.8 510c-19 11-44-3.5-66.8-36.8z"/>
        </svg>

        <div className="text-left">
          <div className="flex items-center gap-1.5">
            <span className="text-[9px] font-bold text-[#60A5FA] uppercase tracking-widest">COMING SOON ON</span>
            <span className="w-1.5 h-1.5 rounded-full bg-[#3B82F6] animate-pulse" />
          </div>
          <p className="text-xs font-black text-white tracking-wide">Google Play</p>
        </div>
      </button>
    </div>
  );
}
