# أطلس حدائق أكتوبر — Website

Static website for the **أطلس حدائق أكتوبر** mobile application.  
Deployed on [Cloudflare Pages](https://pages.cloudflare.com/) at:

> **https://atlas-hadayek-october.pages.dev**

---

## Structure

```
website/
  index.html           → User guide (دليل الاستخدام الفني)
  privacy-policy.html  → Privacy policy (سياسة الخصوصية)
  README.md            → This file
```

---

## Pages

| Page | URL | Description |
|------|-----|-------------|
| User Guide | `/` | Full technical guide covering all app features |
| Privacy Policy | `/privacy-policy` | Required for Google Play Store submission |

---

## Tech Stack

- Pure HTML + CSS — no frameworks, no build step
- Font: [Cairo](https://fonts.google.com/specimen/Cairo) via Google Fonts (Arabic RTL support)
- Hosted on: Cloudflare Pages (free plan)
- Direction: RTL (right-to-left) Arabic

---

## Deployment

This site is deployed automatically via Cloudflare Pages from the `website/production` branch.

To deploy manually:
1. Push changes to `website/production` branch
2. Cloudflare Pages picks up the changes automatically
3. Deployment takes ~30 seconds

---

## Updating Content

| What to update | Where |
|----------------|-------|
| App version number | `index.html` → sidebar footer + contact section |
| Phone / email | Both `index.html` and `privacy-policy.html` → contact sections |
| Privacy policy date | `privacy-policy.html` → changes section + sidebar footer |
| App features | `index.html` → relevant section |

---

## Related

- **Flutter App:** `../` (root of repository)
- **Play Store:** *(link after publish)*
- **Privacy Policy URL for Play Store:** `https://atlas-hadayek-october.pages.dev/privacy-policy`

---

© 2026 أطلس حدائق أكتوبر. All rights reserved.