import React from 'react';

/**
 * VYNK Logo Component — Renders the EXACT logo uploaded by the user.
 * 
 * Props:
 * - variant: 'wordmark' | 'icon-dark' | 'icon-mono' | 'icon-gradient'
 * - size: 'sm' | 'md' | 'lg' | 'xl'
 * - showTagline: boolean
 */
export default function Logo({ 
  variant = 'wordmark', 
  size = 'md', 
  showTagline = false,
  className = '' 
}) {
  const heightMap = {
    sm: 'h-6 sm:h-7',
    md: 'h-8 sm:h-9',
    lg: 'h-11 sm:h-12',
    xl: 'h-16 sm:h-20',
  }[size] || 'h-8';

  const iconSizeMap = {
    sm: 'w-7 h-7',
    md: 'w-9 h-9',
    lg: 'w-12 h-12',
    xl: 'w-16 h-16',
  }[size] || 'w-9 h-9';

  if (variant === 'icon-dark') {
    return (
      <img 
        src="/vynk_icon_dark.png" 
        alt="Vynk App Icon Dark" 
        className={`${iconSizeMap} object-contain rounded-2xl shadow-lg shadow-[#FF4D67]/20 ${className}`}
      />
    );
  }

  if (variant === 'icon-mono') {
    return (
      <img 
        src="/vynk_icon_mono.png" 
        alt="Vynk App Icon Mono" 
        className={`${iconSizeMap} object-contain rounded-2xl shadow-lg ${className}`}
      />
    );
  }

  if (variant === 'icon-gradient') {
    return (
      <div className={`rounded-2xl p-0.5 bg-gradient-to-br from-[#FF4D67] to-[#7C3AED] shadow-lg shadow-[#FF4D67]/30 ${className}`}>
        <img 
          src="/vynk_icon_grad.png" 
          alt="Vynk App Icon Gradient" 
          className={`${iconSizeMap} object-contain rounded-2xl`}
        />
      </div>
    );
  }

  // Exact Uploaded VYNK Wordmark Graphic
  return (
    <div className={`flex flex-col items-start select-none group cursor-pointer ${className}`}>
      <img 
        src="/vynk_wordmark_transparent.png" 
        alt="VYNK Logo" 
        className={`${heightMap} w-auto object-contain drop-shadow-[0_0_15px_rgba(255,77,103,0.3)] transition-transform duration-300 group-hover:scale-[1.02]`}
      />

      {showTagline && (
        <span className="text-[10px] font-bold tracking-[0.25em] text-gray-400 uppercase mt-1">
          PEOPLE <span className="text-[#FF4D67]">×</span> PERSONALITY <span className="text-[#7C3AED]">×</span> POSSIBILITY
        </span>
      )}
    </div>
  );
}
