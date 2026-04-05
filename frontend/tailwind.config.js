/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Golden shiny palette
        gold: {
          50: "#fffbf0",
          100: "#fef5e7",
          200: "#fde8c9",
          300: "#fdd9a3",
          400: "#fcc575",
          500: "#fbb040",
          600: "#e89c1c",
          700: "#d17f0f",
          800: "#a86407",
          900: "#6d3c00",
        },
        // Lavender palette
        lavender: {
          50: "#f9f7ff",
          100: "#f0ecff",
          200: "#e1d5ff",
          300: "#c9b1ff",
          400: "#ad7dff",
          500: "#9555ff",
          600: "#7f3fe8",
          700: "#6a2ed1",
          800: "#5623ab",
          900: "#3d1680",
        },
        // Vynq brand colors
        vynq: {
          primary: "#fbb040",      // Golden
          secondary: "#9555ff",     // Lavender
          accent: "#f9f7ff",        // Light lavender
          dark: "#3d1680",          // Dark lavender
          light: "#fffbf0",         // Light golden
        }
      },
      backgroundImage: {
        'gradient-gold-lavender': 'linear-gradient(135deg, #fbb040 0%, #9555ff 100%)',
        'gradient-lavender-gold': 'linear-gradient(135deg, #9555ff 0%, #fbb040 100%)',
        'gradient-subtle': 'linear-gradient(135deg, #fffbf0 0%, #f9f7ff 100%)',
      },
      boxShadow: {
        'golden': '0 10px 30px rgba(251, 176, 64, 0.15)',
        'lavender': '0 10px 30px rgba(149, 85, 255, 0.15)',
        'glow': '0 0 20px rgba(251, 176, 64, 0.3)',
      },
      fontFamily: {
        'sans': ['Inter', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        'display': ['Poppins', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      }
    },
  },
  plugins: [],
}
