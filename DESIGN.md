---
name: Rainy Gray Aesthetic
colors:
  surface: '#111316'
  surface-dim: '#111316'
  surface-bright: '#37393d'
  surface-container-lowest: '#0c0e11'
  surface-container-low: '#1a1c1f'
  surface-container: '#1e2023'
  surface-container-high: '#282a2d'
  surface-container-highest: '#333538'
  on-surface: '#e2e2e6'
  on-surface-variant: '#c2c7cb'
  inverse-surface: '#e2e2e6'
  inverse-on-surface: '#2f3034'
  outline: '#8c9195'
  outline-variant: '#42484b'
  surface-tint: '#b1cad7'
  primary: '#b1cad7'
  on-primary: '#1c333e'
  primary-container: '#7c94a0'
  on-primary-container: '#152d37'
  inverse-primary: '#4a626d'
  secondary: '#b4cad6'
  on-secondary: '#1e333c'
  secondary-container: '#374c56'
  on-secondary-container: '#a6bcc7'
  tertiary: '#bbc8d0'
  on-tertiary: '#263238'
  tertiary-container: '#86939a'
  on-tertiary-container: '#1f2b31'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#cde6f4'
  primary-fixed-dim: '#b1cad7'
  on-primary-fixed: '#051e28'
  on-primary-fixed-variant: '#334a55'
  secondary-fixed: '#cfe6f2'
  secondary-fixed-dim: '#b4cad6'
  on-secondary-fixed: '#071e27'
  on-secondary-fixed-variant: '#354a53'
  tertiary-fixed: '#d7e4ec'
  tertiary-fixed-dim: '#bbc8d0'
  on-tertiary-fixed: '#111d23'
  on-tertiary-fixed-variant: '#3c494f'
  background: '#111316'
  on-background: '#e2e2e6'
  surface-variant: '#333538'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
This design system is built upon a moody, atmospheric narrative inspired by a rainy afternoon. The personality is calm, focused, and sophisticated, leaning heavily into a refined Minimalism that prioritizes negative space and clarity. The target audience values deep focus and an unobtrusive interface that feels like a quiet workspace.

The visual style utilizes a "Cool-Gray Mono" approach with subtle Glassmorphic accents to simulate the texture of wet surfaces and mist. This creates a sense of depth without relying on traditional drop shadows, ensuring the UI remains crisp and modern.

## Colors
The palette is centered on a "Rainy Day" spectrum. The background uses a deep, ink-like charcoal to minimize eye strain and provide a canvas for higher-contrast elements. 

- **Primary Slate:** A muted, desaturated blue used for interactive elements and highlights.
- **Surface Grays:** A series of cool-toned grays that provide hierarchical separation between containers and the base background.
- **Text Contrast:** Pure white (#FFFFFF) is reserved for headers, while "Cloud Gray" (#B0BEC5) is used for secondary body text to maintain a soft, legible hierarchy that avoids the harshness of pure white-on-black.

## Typography
The typography strategy balances modern precision with high readability. **Hanken Grotesk** provides a sharp, contemporary edge for headlines, evoking a sense of architectural structure. **Inter** is utilized for body copy due to its exceptional legibility in dark mode environments. For technical metadata or labels, **JetBrains Mono** is introduced to reinforce the "focused/utility" aspect of the design system.

Line heights are intentionally generous to prevent the dense, dark palette from feeling claustrophobic.

## Layout & Spacing
The design system employs a **Fluid Grid** model with a heavy emphasis on "Breathing Room." Layouts should feel expansive, mirroring the openness of an overcast landscape.

- **Desktop:** A 12-column grid with 64px side margins. 
- **Mobile:** A 4-column grid with 16px side margins.
- **Rhythm:** All vertical spacing must follow an 8px baseline shift to maintain mathematical harmony. Components should favor `md` (24px) padding to ensure the "Rainy" aesthetic feels airy rather than cramped.

## Elevation & Depth
In this design system, depth is communicated through **Tonal Elevation** rather than traditional shadows. 

1. **Base Layer:** The deepest charcoal (#121417).
2. **Content Layer:** Elevated surfaces use slightly lighter charcoal (#1A1D23).
3. **Interactive Layer:** Active components use a subtle 1px inner stroke in Slate Blue to simulate a "beveled glass" edge.
4. **Fog Effect:** For modals and overlays, use a background blur (Backdrop Filter: 12px) with a semi-transparent slate overlay (Alpha: 0.4) to mimic the appearance of looking through a rain-streaked window.

## Shapes
The shape language is consistently **Rounded**. A radius of 0.5rem (8px) is the standard for cards and inputs, providing a soft, organic feel that contrasts with the "cold" color palette. 

- **Standard Elements:** 8px (rounded)
- **Large Containers:** 16px (rounded-lg)
- **Feature Modules:** 24px (rounded-xl)

Avoid sharp corners to maintain the approachable, calm persona of the brand.

## Components
Consistent component styling reinforces the rainy, focused aesthetic:

- **Buttons:** Primary buttons use a solid Slate Blue with high-contrast white text. Secondary buttons are "Ghost" style with a 1px Slate border. 
- **Inputs:** Fields are dark charcoal with a subtle bottom-border highlight. Upon focus, the border transitions to a glowing Slate Blue.
- **Cards:** Use a subtle background blur and a 1px border (#263238). Avoid heavy shadows; instead, use a 2px vertical offset with a low-opacity blue tint for "hover" states.
- **Chips:** Small, pill-shaped elements with monochromatic fills. Use JetBrains Mono for the text within chips to denote categorization or tags.
- **Progress Bars:** Thin, high-contrast Slate lines against a dark track, evoking a clinical, precise feel.