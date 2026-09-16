/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        vynk: {
          bg: "#0D0D0D",
          surface: "#1A1A2E",
          surfaceLight: "#252542",
          card: "#16162A",
          primary: "#FF4D67",
          primaryHover: "#FF3352",
          secondary: "#7C3AED",
          secondaryLight: "#A78BFA",
          gold: "#FFD700",
          blue: "#3B82F6",
          muted: "#6B7280",
          lightMuted: "#9CA3AF",
        },
      },
      fontFamily: {
        sans: ["Outfit", "sans-serif"],
      },
      backgroundImage: {
        "hero-gradient": "linear-gradient(135deg, #FF4D67 0%, #7C3AED 100%)",
        "glow-gradient": "radial-gradient(circle at center, rgba(255, 77, 103, 0.15) 0%, rgba(124, 58, 237, 0.05) 50%, transparent 70%)",
        "card-gradient": "linear-gradient(145deg, rgba(26, 26, 46, 0.8) 0%, rgba(22, 22, 42, 0.9) 100%)",
        "glass-gradient": "linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.02) 100%)",
      },
      animation: {
        "float": "float 6s ease-in-out infinite",
        "float-delayed": "float 6s ease-in-out 3s infinite",
        "pulse-glow": "pulseGlow 4s ease-in-out infinite",
        "shimmer": "shimmer 2.5s linear infinite",
        "orbit": "orbit 20s linear infinite",
      },
      keyframes: {
        float: {
          "0%, 100%": { transform: "translateY(0px)" },
          "50%": { transform: "translateY(-12px)" },
        },
        pulseGlow: {
          "0%, 100%": { opacity: "0.4", transform: "scale(1)" },
          "50%": { opacity: "0.8", transform: "scale(1.05)" },
        },
        shimmer: {
          "0%": { backgroundPosition: "-200% 0" },
          "100%": { backgroundPosition: "200% 0" },
        },
      },
      boxShadow: {
        "coral-glow": "0 0 30px -5px rgba(255, 77, 103, 0.4)",
        "violet-glow": "0 0 30px -5px rgba(124, 58, 237, 0.4)",
        "glass-glow": "0 8px 32px 0 rgba(0, 0, 0, 0.37)",
      },
    },
  },
  plugins: [],
}
