/**
 * Smart City Portal — Interactive JS
 * Scroll-reveal, sidebar toggle, toast notifications, FAQ accordion
 * Vanilla JS, no dependencies, <5kb
 */
(function () {
  'use strict';

  /* ── Sidebar Toggle (mobile) ── */
  const sidebar        = document.querySelector('.sidebar');
  const toggle         = document.querySelector('.sidebar-toggle');
  const overlay        = document.querySelector('.sidebar-overlay');

  function openSidebar() {
    sidebar?.classList.add('open');
    overlay?.classList.add('open');
    document.body.style.overflow = 'hidden';
  }
  function closeSidebar() {
    sidebar?.classList.remove('open');
    overlay?.classList.remove('open');
    document.body.style.overflow = '';
  }
  toggle?.addEventListener('click', () => {
    sidebar?.classList.contains('open') ? closeSidebar() : openSidebar();
  });
  overlay?.addEventListener('click', closeSidebar);

  /* ── Scroll-Reveal (IntersectionObserver) ── */
  const revealEls = document.querySelectorAll('.reveal, .reveal-left');
  if (revealEls.length) {
    const revealObs = new IntersectionObserver((entries) => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          e.target.classList.add('visible');
          revealObs.unobserve(e.target);
        }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });
    revealEls.forEach(el => revealObs.observe(el));
  }

  /* ── FAQ Accordion ── */
  document.querySelectorAll('.faq-question').forEach(btn => {
    btn.addEventListener('click', () => {
      const item   = btn.closest('.faq-item');
      const answer = item.querySelector('.faq-answer');
      const isOpen = item.classList.contains('open');
      // Close all
      document.querySelectorAll('.faq-item.open').forEach(i => {
        i.classList.remove('open');
        i.querySelector('.faq-answer').style.maxHeight = '0';
        i.querySelector('.faq-icon').textContent = '+';
      });
      if (!isOpen) {
        item.classList.add('open');
        answer.style.maxHeight = answer.scrollHeight + 'px';
        item.querySelector('.faq-icon').textContent = '−';
      }
    });
  });

  /* ── Toast Notification System ── */
  window.showToast = function(message, type = 'info', duration = 3500) {
    let container = document.getElementById('toast-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'toast-container';
      document.body.appendChild(container);
    }
    const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `<span>${icons[type] || icons.info}</span><span>${message}</span>`;
    container.appendChild(toast);
    setTimeout(() => {
      toast.classList.add('removing');
      toast.addEventListener('animationend', () => toast.remove(), { once: true });
    }, duration);
  };

  /* ── Auto-show toasts from server messages ── */
  document.querySelectorAll('.alert-success').forEach(el => {
    showToast(el.textContent.trim(), 'success');
  });
  document.querySelectorAll('.alert-danger, .alert-err').forEach(el => {
    showToast(el.textContent.trim(), 'error');
  });

  /* ── Button ripple effect ── */
  document.querySelectorAll('.btn, .sc-btn, .btn-login, .btn-reg').forEach(btn => {
    btn.addEventListener('click', function(e) {
      const rect = this.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      const ripple = document.createElement('span');
      Object.assign(ripple.style, {
        position: 'absolute',
        borderRadius: '50%',
        width: '6px', height: '6px',
        background: 'rgba(255,255,255,0.4)',
        left: x + 'px', top: y + 'px',
        transform: 'translate(-50%,-50%) scale(0)',
        animation: 'rippleAnim 0.45s ease-out forwards',
        pointerEvents: 'none'
      });
      this.style.position = this.style.position || 'relative';
      this.appendChild(ripple);
      setTimeout(() => ripple.remove(), 500);
    });
  });
  // Add ripple keyframe dynamically once
  if (!document.getElementById('ripple-style')) {
    const style = document.createElement('style');
    style.id = 'ripple-style';
    style.textContent = `@keyframes rippleAnim {
      to { transform: translate(-50%,-50%) scale(22); opacity: 0; }
    }`;
    document.head.appendChild(style);
  }

  /* ── Smooth scroll for anchor links ── */
  document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', e => {
      const target = document.querySelector(link.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  /* ── Animated stat counters ── */
  function animateCounter(el) {
    const target = parseInt(el.dataset.target || el.textContent, 10);
    if (isNaN(target)) return;
    const duration = 800;
    const step     = 16;
    const steps    = Math.ceil(duration / step);
    let   current  = 0;
    el.textContent = '0';
    const timer = setInterval(() => {
      current += Math.ceil(target / steps);
      if (current >= target) { el.textContent = target; clearInterval(timer); }
      else el.textContent = current;
    }, step);
  }
  const counterEls = document.querySelectorAll('.s-num[data-target]');
  if (counterEls.length) {
    const cObs = new IntersectionObserver((entries) => {
      entries.forEach(e => {
        if (e.isIntersecting) { animateCounter(e.target); cObs.unobserve(e.target); }
      });
    }, { threshold: 0.5 });
    counterEls.forEach(el => cObs.observe(el));
  }

  /* ── Sticky nav shrink on scroll (landing page) ── */
  const topNav = document.querySelector('.top-nav');
  if (topNav) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 40) topNav.classList.add('scrolled');
      else topNav.classList.remove('scrolled');
    }, { passive: true });
  }

})();
