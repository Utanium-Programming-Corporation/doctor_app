# Shadows

> Extracted from Figma design system

## Shadow Tokens

| Name | Token | Layers |
|------|-------|--------|
| XSmall | `shadow-xs` | 1 layer |
| Small | `shadow-s` | 2 layers |
| Medium | `shadow-m` | 2 layers |
| Large | `shadow-l` | 2 layers |
| XLarge | `shadow-xl` | 1 layer |
| XXLarge | `shadow-2xl` | 1 layer |

---

## Shadow Details

### XSmall

```css
box-shadow: 0px 1px 2px 0px rgba(13, 13, 18, 0.06);
```

| Property | Value |
|----------|-------|
| Offset X | 0px |
| Offset Y | 1px |
| Blur | 2px |
| Spread | 0px |
| Color | `rgba(13, 13, 18, 0.06)` |

---

### Small

```css
box-shadow:
  0px 1px 3px 0px rgba(13, 13, 18, 0.05),
  0px 1px 2px 0px rgba(13, 13, 18, 0.04);
```

| Layer | Offset X | Offset Y | Blur | Spread | Color |
|-------|----------|----------|------|--------|-------|
| 1 | 0px | 1px | 3px | 0px | `rgba(13, 13, 18, 0.05)` |
| 2 | 0px | 1px | 2px | 0px | `rgba(13, 13, 18, 0.04)` |

---

### Medium

```css
box-shadow:
  0px 5px 10px -2px rgba(13, 13, 18, 0.04),
  0px 4px 8px -1px rgba(13, 13, 18, 0.02);
```

| Layer | Offset X | Offset Y | Blur | Spread | Color |
|-------|----------|----------|------|--------|-------|
| 1 | 0px | 5px | 10px | -2px | `rgba(13, 13, 18, 0.04)` |
| 2 | 0px | 4px | 8px | -1px | `rgba(13, 13, 18, 0.02)` |

---

### Large

```css
box-shadow:
  0px 12px 16px -4px rgba(13, 13, 18, 0.08),
  0px 4px 6px -2px rgba(13, 13, 18, 0.03);
```

| Layer | Offset X | Offset Y | Blur | Spread | Color |
|-------|----------|----------|------|--------|-------|
| 1 | 0px | 12px | 16px | -4px | `rgba(13, 13, 18, 0.08)` |
| 2 | 0px | 4px | 6px | -2px | `rgba(13, 13, 18, 0.03)` |

---

### XLarge

```css
box-shadow: 0px 24px 48px -12px rgba(13, 13, 18, 0.18);
```

| Property | Value |
|----------|-------|
| Offset X | 0px |
| Offset Y | 24px |
| Blur | 48px |
| Spread | -12px |
| Color | `rgba(13, 13, 18, 0.18)` |

---

### XXLarge

```css
box-shadow: 0px 24px 48px -12px rgba(13, 13, 18, 0.18);
```

| Property | Value |
|----------|-------|
| Offset X | 0px |
| Offset Y | 24px |
| Blur | 48px |
| Spread | -12px |
| Color | `rgba(13, 13, 18, 0.18)` |

---

## CSS Variables Reference

```css
/* Shadow Tokens */
--shadow-xs: 0px 1px 2px 0px rgba(13, 13, 18, 0.06);
--shadow-s: 0px 1px 3px 0px rgba(13, 13, 18, 0.05),
            0px 1px 2px 0px rgba(13, 13, 18, 0.04);
--shadow-m: 0px 5px 10px -2px rgba(13, 13, 18, 0.04),
            0px 4px 8px -1px rgba(13, 13, 18, 0.02);
--shadow-l: 0px 12px 16px -4px rgba(13, 13, 18, 0.08),
            0px 4px 6px -2px rgba(13, 13, 18, 0.03);
--shadow-xl: 0px 24px 48px -12px rgba(13, 13, 18, 0.18);
--shadow-2xl: 0px 24px 48px -12px rgba(13, 13, 18, 0.18);
```

## Tailwind Reference

```js
// tailwind.config.js
theme: {
  extend: {
    boxShadow: {
      xs: '0px 1px 2px 0px rgba(13, 13, 18, 0.06)',
      s: '0px 1px 3px 0px rgba(13, 13, 18, 0.05), 0px 1px 2px 0px rgba(13, 13, 18, 0.04)',
      m: '0px 5px 10px -2px rgba(13, 13, 18, 0.04), 0px 4px 8px -1px rgba(13, 13, 18, 0.02)',
      l: '0px 12px 16px -4px rgba(13, 13, 18, 0.08), 0px 4px 6px -2px rgba(13, 13, 18, 0.03)',
      xl: '0px 24px 48px -12px rgba(13, 13, 18, 0.18)',
      '2xl': '0px 24px 48px -12px rgba(13, 13, 18, 0.18)',
    }
  }
}
```
