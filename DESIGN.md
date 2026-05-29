---
name: Lumina Guardian
colors:
  surface: '#fbf9f8'
  surface-dim: '#dbd9d9'
  surface-bright: '#fbf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f3'
  surface-container: '#efeded'
  surface-container-high: '#eae8e7'
  surface-container-highest: '#e4e2e2'
  on-surface: '#1b1c1c'
  on-surface-variant: '#574146'
  inverse-surface: '#303030'
  inverse-on-surface: '#f2f0f0'
  outline: '#8a7176'
  outline-variant: '#ddbfc5'
  surface-tint: '#ab2c5d'
  primary: '#ab2c5d'
  on-primary: '#ffffff'
  primary-container: '#f06292'
  on-primary-container: '#5e002b'
  inverse-primary: '#ffb1c5'
  secondary: '#625d60'
  on-secondary: '#ffffff'
  secondary-container: '#e8e0e3'
  on-secondary-container: '#686366'
  tertiary: '#5d5f5f'
  on-tertiary: '#ffffff'
  tertiary-container: '#939494'
  on-tertiary-container: '#2b2d2d'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffd9e1'
  primary-fixed-dim: '#ffb1c5'
  on-primary-fixed: '#3f001b'
  on-primary-fixed-variant: '#8b0e45'
  secondary-fixed: '#e8e0e3'
  secondary-fixed-dim: '#ccc5c8'
  on-secondary-fixed: '#1e1b1d'
  on-secondary-fixed-variant: '#4a4648'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#fbf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e4e2e2'
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Montserrat
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: beVietnamPro
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: beVietnamPro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: beVietnamPro
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: beVietnamPro
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 8px
  container-padding-mobile: 24px
  container-padding-desktop: 64px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

This design system is built on the philosophy of "Digital Guardianship"—a blend of high-tech reliability and soft, human-centric empathy. The brand personality is caring, protective, and intelligent, specifically avoiding the cold, clinical, or authoritative aesthetic often associated with security apps.

The visual style employs **Minimalism** enriched with **Glassmorphism**. It uses expansive white space and a soft color palette to reduce anxiety, while translucent layers and subtle background blurs create a sense of futuristic sophistication. The interface should feel like a premium concierge service—always present, highly capable, but never intrusive.

## Colors

The palette is anchored by **Rose Pink**, a color chosen for its warmth and feminine strength. This is balanced against a **Soft Pink** background that reduces eye strain and provides a soothing canvas.

- **Primary (Rose Pink):** Used for primary actions, branding, and active navigational states.
- **Background (Soft Pink):** Applied to the main application canvas to create a proprietary, non-generic atmosphere.
- **Surface (Pure White):** Reserved for interactive cards and input fields to ensure maximum legibility and a sense of cleanliness.
- **Semantic States:** Deep Red is reserved exclusively for high-urgency SOS functions to ensure immediate recognition. Emerald Green is used for "Safe" confirmations, providing visual relief and reassurance.

## Typography

The typography strategy pairs the geometric confidence of **Montserrat** for headlines with the warm, approachable clarity of **Be Vietnam Pro** for body text and labels.

Headlines should be bold and authoritative to instill confidence during use. Body text utilizes generous line heights to ensure readability under stress. For mobile, display sizes are capped to prevent text wrapping issues in dense information views, while maintaining a clear visual hierarchy that guides the user’s eye to the most critical information first.

## Layout & Spacing

This design system utilizes a **Fluid Grid** model with high internal margins to evoke a sense of "breathing room" and calm. 

- **Mobile:** A 4-column layout with 24px side margins. This wide margin prevents the UI from feeling cramped and ensures touch targets are comfortably away from screen edges.
- **Desktop/Tablet:** A 12-column centered layout with a maximum content width of 1140px. 
- **Spacing Rhythm:** All vertical and horizontal spacing follows an 8px base unit. Use larger stack spacing (32px+) between distinct functional groups to reinforce the minimalist, organized feel of the application.

## Elevation & Depth

Hierarchy is established through **Ambient Shadows** and **Glassmorphism**, rather than heavy borders or dark overlays.

- **Soft Shadows:** White cards use extremely diffused, low-opacity shadows (Opacity: 8-10%) with a slight tint of Rose Pink (#F06292) in the shadow color. This makes the cards feel like they are floating gently above the soft pink background.
- **Glassmorphism:** Overlays, navigation bars, and floating action buttons use a 20px backdrop blur with a 70% transparent white fill. This maintains context of the screen behind the element while focusing the user on the foreground.
- **Interactive Depth:** On hover or tap, cards should subtly "lift" (increase shadow spread) to provide tactile feedback without looking mechanical.

## Shapes

The shape language is defined by ultra-rounded "Pill" aesthetics. This softness is essential to the brand’s "supportive" promise, removing any sharp or aggressive visual edges.

- **Primary Elements:** All main cards and containers must use a minimum corner radius of 24px. 
- **Buttons & Chips:** Use fully rounded (pill-shaped) ends.
- **Form Inputs:** Utilize a 16px radius to provide a modern, friendly feel while maintaining enough structure for clear text alignment.

## Components

### Buttons
Primary buttons are pill-shaped, using a Rose Pink gradient for a slightly "lit from within" futuristic look. The SOS button is a special case: a large circular floating element with a pulsating outer glow in Deep Red to indicate it is active and "listening."

### Cards
Cards are pure white with 24px+ rounded corners and a 1px semi-transparent white border to catch highlights. They should be used to group related safety information or contact shortcuts.

### Input Fields
Fields should have a soft white background (different from the page background) and use 16px rounded corners. The focus state should be a soft 2px Rose Pink glow rather than a hard outline.

### Chips & Badges
Used for status indicators (e.g., "Safe," "Tracking On"). These should be small, pill-shaped, and use low-saturation versions of the status colors with high-contrast text for accessibility.

### High-Quality Iconography
Icons should use a "Duotone" or "Soft Line" style. Avoid thin, razor-sharp icons; instead, use slightly weighted lines (2px stroke) with rounded terminals to match the typography and shape language.