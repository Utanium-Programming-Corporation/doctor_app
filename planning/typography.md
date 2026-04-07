# Typography

> Extracted from Figma design system

## Fonts

| Font Family | Variants Used |
|-------------|---------------|
| SF Pro Display | Bold, Semibold |
| SF Pro Text | Bold, Semibold, Medium, Regular |

## Color Tokens

| Token | Hex |
|-------|-----|
| Primary/300 | `#108244` |
| Greyscale/900 | `#0D0D12` |
| Greyscale/500 | `#666D80` |
| Greyscale/400 | `#898D93` |
| Greyscale/200 | `#E2E8F0` |
| White/900 | `#FFFFFF` |

---

## Headings

| Style | Font Family | Weight | Size | Line Height | Letter Spacing |
|-------|-------------|--------|------|-------------|----------------|
| H1 | SF Pro Display | Bold (700) | 48px | 1.2 (57.6px) | -2px |
| H2 | SF Pro Display | Bold (700) | 40px | 1.2 (48px) | -2px |
| H3 | SF Pro Display | Bold (700) | 32px | 1.4 (44.8px) | -2px |
| H4 | SF Pro Display | Bold (700) | 24px | 1.33 (32px) | 0 |
| H5 | SF Pro Text | Bold (700) | 20px | 1.4 (28px) | 0 |
| H6 | SF Pro Text | Bold (700) | 18px | 1.4 (25.2px) | 0 |

---

## Body

### Body Large (18px)

| Style | Font Family | Weight | Size | Line Height | Letter Spacing |
|-------|-------------|--------|------|-------------|----------------|
| bodyBold18 | SF Pro Text | Bold (700) | 18px | 1.55 (27.9px) | 0 |
| bodyMedium18 | SF Pro Text | Medium (500) | 18px | 1.55 (27.9px) | 0 |
| bodyRegular18 | SF Pro Text | Regular (400) | 18px | 1.55 (27.9px) | 0 |

### Body Medium (16px)

| Style | Font Family | Weight | Size | Line Height | Letter Spacing |
|-------|-------------|--------|------|-------------|----------------|
| bodyBold16 | SF Pro Text | Bold (700) | 16px | 1.55 (24.8px) | 0 |
| bodyMedium16 | SF Pro Text | Medium (500) | 16px | 1.6 (25.6px) | 0 |
| bodyRegular16 | SF Pro Text | Regular (400) | 16px | 1.6 (25.6px) | 0 |

### Body Small (14px)

| Style | Font Family | Weight | Size | Line Height | Letter Spacing |
|-------|-------------|--------|------|-------------|----------------|
| bodyBold14 | SF Pro Text | Bold (700) | 14px | 1.55 (21.7px) | 0 |
| bodyMedium14 | SF Pro Text | Medium (500) | 14px | 1.55 (21.7px) | 0 |
| bodyRegular14 | SF Pro Text | Regular (400) | 14px | 1.55 (21.7px) | 0 |

### Body XSmall (12px)

| Style | Font Family | Weight | Size | Line Height | Letter Spacing |
|-------|-------------|--------|------|-------------|----------------|
| bodyBold12 | SF Pro Text | Bold (700) | 12px | 1.55 (18.6px) | 0 |
| bodyMedium12 | SF Pro Text | Medium (500) | 12px | 1.55 (18.6px) | 0 |
| bodyRegular12 | SF Pro Text | Regular (400) | 12px | 1.55 (18.6px) | 0 |

---

## CSS Variables Reference

```css
/* Font Families */
--font-display: 'SF Pro Display', sans-serif;
--font-text: 'SF Pro Text', sans-serif;

/* Heading Styles */
--heading-h1: 700 48px/1.2 var(--font-display);    /* letter-spacing: -2px */
--heading-h2: 700 40px/1.2 var(--font-display);    /* letter-spacing: -2px */
--heading-h3: 700 32px/1.4 var(--font-display);    /* letter-spacing: -2px */
--heading-h4: 700 24px/1.33 var(--font-display);
--heading-h5: 700 20px/1.4 var(--font-text);
--heading-h6: 700 18px/1.4 var(--font-text);

/* Body Large */
--body-bold-18: 700 18px/1.55 var(--font-text);
--body-medium-18: 500 18px/1.55 var(--font-text);
--body-regular-18: 400 18px/1.55 var(--font-text);

/* Body Medium */
--body-bold-16: 700 16px/1.55 var(--font-text);
--body-medium-16: 500 16px/1.6 var(--font-text);
--body-regular-16: 400 16px/1.6 var(--font-text);

/* Body Small */
--body-bold-14: 700 14px/1.55 var(--font-text);
--body-medium-14: 500 14px/1.55 var(--font-text);
--body-regular-14: 400 14px/1.55 var(--font-text);

/* Body XSmall */
--body-bold-12: 700 12px/1.55 var(--font-text);
--body-medium-12: 500 12px/1.55 var(--font-text);
--body-regular-12: 400 12px/1.55 var(--font-text);

/* Text Colors */
--text-primary: #121A26;
--text-secondary: #666D80;
--text-tertiary: #898D93;
--text-inverse: #FFFFFF;
```
