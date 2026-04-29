/**
 * Smart City Portal — Enhanced Interactive Features
 * Additive layer on top of main.js
 */
(function(){
'use strict';

/* ══════════════════════════════════════
   1. DARK MODE TOGGLE
   ══════════════════════════════════════ */
const THEME_KEY = 'scp-theme';
function getTheme(){ return localStorage.getItem(THEME_KEY) || 'light'; }
function applyTheme(t){ document.documentElement.setAttribute('data-theme',t); localStorage.setItem(THEME_KEY,t); document.querySelectorAll('.theme-toggle').forEach(b=>b.textContent=t==='dark'?'☀️':'🌙'); }
applyTheme(getTheme());
document.addEventListener('click',e=>{
  if(e.target.closest('.theme-toggle')){ applyTheme(getTheme()==='dark'?'light':'dark'); }
});

/* ══════════════════════════════════════
   2. NOTIFICATION SYSTEM
   ══════════════════════════════════════ */
const notifMessages = [
  {icon:'📋',cls:'ni-info',text:'Complaint <strong>#3</strong> status changed to <strong>In Progress</strong>',time:'2 min ago'},
  {icon:'🏥',cls:'ni-success',text:'Appointment <strong>#1</strong> has been <strong>Confirmed</strong>',time:'15 min ago'},
  {icon:'💡',cls:'ni-warning',text:'Bill <strong>#2</strong> due date is approaching',time:'1 hour ago'},
  {icon:'📢',cls:'ni-info',text:'New announcement: <strong>Water Supply Disruption</strong>',time:'3 hours ago'},
  {icon:'✅',cls:'ni-success',text:'Complaint <strong>#4</strong> has been <strong>Resolved</strong>',time:'5 hours ago'},
];
document.addEventListener('click',e=>{
  const bell=e.target.closest('.notif-bell');
  if(bell){ const dd=bell.closest('.notif-wrap').querySelector('.notif-dropdown'); dd.classList.toggle('open'); e.stopPropagation(); return; }
  if(!e.target.closest('.notif-dropdown')) document.querySelectorAll('.notif-dropdown.open').forEach(d=>d.classList.remove('open'));
  const clearBtn=e.target.closest('.notif-clear');
  if(clearBtn){ const dd=clearBtn.closest('.notif-dropdown'); dd.querySelector('.notif-list').innerHTML='<div class="notif-empty">🔔 All caught up!</div>'; const badge=dd.closest('.notif-wrap').querySelector('.notif-badge'); if(badge)badge.style.display='none'; }
});
function populateNotifs(){
  document.querySelectorAll('.notif-list').forEach(list=>{
    if(list.children.length>0 && !list.querySelector('.notif-empty')) return;
    list.innerHTML=notifMessages.map(n=>`<div class="notif-item"><div class="notif-icon ${n.cls}">${n.icon}</div><div><div class="notif-text">${n.text}</div><div class="notif-time">${n.time}</div></div></div>`).join('');
  });
}
setTimeout(populateNotifs,300);

/* ══════════════════════════════════════
   3. GLOBAL SEARCH
   ══════════════════════════════════════ */
const searchLinks=[
  {icon:'📋',label:'File Complaint',desc:'Report civic issues',url:'/complaint?action=new'},
  {icon:'🔍',label:'My Complaints',desc:'Track complaint status',url:'/complaint?action=list'},
  {icon:'🏥',label:'Book Appointment',desc:'Hospital consultation',url:'/appointment?action=new'},
  {icon:'💡',label:'Utility Bills',desc:'View and pay bills',url:'/bill?action=list'},
  {icon:'📢',label:'Announcements',desc:'City notices',url:'/announcement'},
  {icon:'👤',label:'My Profile',desc:'Account details',url:'/citizen/profile.jsp'},
  {icon:'📊',label:'Dashboard',desc:'Overview',url:'/citizen/dashboard.jsp'},
];
document.addEventListener('click',e=>{
  if(e.target.closest('.search-trigger')){ openSearch(); }
  if(e.target.closest('.search-modal') && !e.target.closest('.search-box')){ closeSearch(); }
  const item=e.target.closest('.search-result-item');
  if(item){ const ctx=document.querySelector('meta[name="ctx"]'); const base=ctx?ctx.content:''; window.location.href=base+item.dataset.url; }
});
document.addEventListener('keydown',e=>{
  if((e.ctrlKey||e.metaKey)&&e.key==='k'){ e.preventDefault(); openSearch(); }
  if(e.key==='Escape'){ closeSearch(); closeShortcuts(); }
  if((e.ctrlKey||e.metaKey)&&e.key==='d'){ e.preventDefault(); applyTheme(getTheme()==='dark'?'light':'dark'); }
  if(e.key==='?' && !e.target.closest('input,textarea,select')){ openShortcuts(); }
});
function openSearch(){
  const m=document.querySelector('.search-modal'); if(!m)return;
  m.classList.add('open'); const inp=m.querySelector('.search-input'); if(inp){inp.value='';inp.focus();} renderSearchResults('');
}
function closeSearch(){ document.querySelectorAll('.search-modal.open').forEach(m=>m.classList.remove('open')); }
document.addEventListener('input',e=>{
  if(e.target.classList.contains('search-input')){ renderSearchResults(e.target.value); }
});
function renderSearchResults(q){
  const container=document.querySelector('.search-results'); if(!container)return;
  const filtered=q?searchLinks.filter(l=>l.label.toLowerCase().includes(q.toLowerCase())||l.desc.toLowerCase().includes(q.toLowerCase())):searchLinks;
  container.innerHTML=`<div class="search-group-title">Quick Actions</div>`+
    filtered.map(l=>`<a class="search-result-item" data-url="${l.url}" href="#"><span class="sri-icon">${l.icon}</span><span>${l.label}<br><small style="color:var(--muted);font-size:.7rem">${l.desc}</small></span></a>`).join('')
    +(filtered.length===0?'<div class="notif-empty">No results found</div>':'');
}

/* ══════════════════════════════════════
   4. TABLE FILTERS
   ══════════════════════════════════════ */
document.addEventListener('click',e=>{
  const pill=e.target.closest('.filter-pill');
  if(!pill)return;
  const bar=pill.closest('.filter-bar');
  bar.querySelectorAll('.filter-pill').forEach(p=>p.classList.remove('active'));
  pill.classList.add('active');
  applyFilters(bar);
});
document.addEventListener('input',e=>{
  if(e.target.classList.contains('filter-search')){ applyFilters(e.target.closest('.filter-bar')); }
});
function applyFilters(bar){
  if(!bar)return;
  const card=bar.closest('.card')||bar.nextElementSibling;
  const table=card?card.querySelector('.sc-table'):document.querySelector('.sc-table');
  if(!table)return;
  const activePill=bar.querySelector('.filter-pill.active');
  const filterVal=activePill?activePill.dataset.filter:'all';
  const searchVal=(bar.querySelector('.filter-search')||{}).value||'';
  const rows=table.querySelectorAll('tbody tr');
  let count=0;
  rows.forEach(row=>{
    const text=row.textContent.toLowerCase();
    const badges=row.querySelectorAll('.badge');
    let statusMatch=filterVal==='all';
    badges.forEach(b=>{ if(b.textContent.trim().toLowerCase().includes(filterVal.toLowerCase())) statusMatch=true; });
    const searchMatch=!searchVal||text.includes(searchVal.toLowerCase());
    const show=statusMatch&&searchMatch;
    row.style.display=show?'':'none';
    if(show)count++;
  });
  const countEl=bar.querySelector('.filter-count');
  if(countEl) countEl.textContent=count+' results';
}

/* ══════════════════════════════════════
   5. COMPLAINT TIMELINE TRACKER
   ══════════════════════════════════════ */
function injectTimelines(){
  document.querySelectorAll('.sc-table').forEach(table=>{
    const headers=table.querySelectorAll('th');
    let statusIdx=-1;
    headers.forEach((h,i)=>{ if(h.textContent.trim().toLowerCase()==='status') statusIdx=i; });
    if(statusIdx<0)return;
    const pageText=document.title.toLowerCase();
    if(!pageText.includes('complaint'))return;
    // Add timeline header
    const hasTimeline=table.querySelector('.th-timeline');
    if(hasTimeline)return;
    const th=document.createElement('th'); th.className='th-timeline'; th.textContent='Progress'; headers[0].closest('tr').appendChild(th);
    table.querySelectorAll('tbody tr').forEach(row=>{
      const cells=row.querySelectorAll('td');
      if(cells.length<statusIdx+1)return;
      const badge=cells[statusIdx].querySelector('.badge');
      const status=badge?badge.textContent.trim():'Pending';
      const td=document.createElement('td');
      const steps=['Submitted','In Progress','Resolved'];
      const currentIdx=status==='Resolved'?2:status==='In Progress'?1:0;
      let html='<div class="timeline-tracker">';
      steps.forEach((s,i)=>{
        const cls=i<currentIdx?'done':i===currentIdx?'current':'';
        html+=`<div class="tl-step ${cls}"><div class="tl-dot">${i<currentIdx?'✓':i+1}</div><div class="tl-label">${s}</div></div>`;
        if(i<steps.length-1) html+=`<div class="tl-line ${i<currentIdx?'done':''}"></div>`;
      });
      html+='</div>';
      td.innerHTML=html;
      row.appendChild(td);
    });
  });
}
setTimeout(injectTimelines,200);

/* ══════════════════════════════════════
   6. CHART.JS INTEGRATION
   ══════════════════════════════════════ */
function loadChartJS(cb){
  if(window.Chart){ cb(); return; }
  const s=document.createElement('script');
  s.src='https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js';
  s.onload=cb; document.head.appendChild(s);
}
function initCharts(){
  // Admin dashboard charts
  const chartGrid=document.getElementById('enhancedCharts');
  if(!chartGrid)return;
  loadChartJS(()=>{
    const statNums=document.querySelectorAll('.s-num[data-target]');
    const vals={}; statNums.forEach(el=>{
      const label=(el.closest('.stat-card')?.querySelector('.s-label')||{}).textContent||'';
      vals[label.trim()]=parseInt(el.dataset.target)||0;
    });
    // Doughnut - complaint status
    const c1=document.getElementById('chartComplaintStatus');
    if(c1){
      const pending=vals['Complaints Pending']||0;
      const total=vals['Total Complaints']||0;
      const resolved=Math.max(0,total-pending);
      new Chart(c1,{type:'doughnut',data:{labels:['Resolved','Pending'],datasets:[{data:[resolved,pending],backgroundColor:['#00ff88','#ffaa00'],borderWidth:0}]},options:{responsive:true,plugins:{legend:{position:'bottom',labels:{color:'#b8b4ae',font:{size:11,family:'Inter'},padding:12}}}}});
    }
    // Bar - overview
    const c2=document.getElementById('chartOverview');
    if(c2){
      new Chart(c2,{type:'bar',data:{labels:['Citizens','Complaints','Appointments','Unpaid Bills','Announcements'],datasets:[{label:'Count',data:[vals['Registered Citizens']||0,vals['Total Complaints']||0,vals['Total Appointments']||0,vals['Bills Unpaid']||0,vals['Announcements Posted']||0],backgroundColor:['#00e5ff','#ffaa00','#00ff88','#ff4466','#a855f7'],borderRadius:6,borderWidth:0}]},options:{responsive:true,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,ticks:{color:'#6b6b6b'},grid:{color:'rgba(255,255,255,.05)'}},x:{ticks:{color:'#6b6b6b'},grid:{display:false}}}}});
    }
  });
}
setTimeout(initCharts,400);

/* ══════════════════════════════════════
   7. SMART COMPLAINT SUGGESTIONS
   ══════════════════════════════════════ */
const suggestionMap={
  'pothole':'Road','road':'Road','crack':'Road','broken road':'Road','highway':'Road',
  'water':'Water','pipe':'Water','leak':'Water','tap':'Water','supply':'Water','drain':'Water',
  'electric':'Electricity','power':'Electricity','light':'Electricity','wire':'Electricity','outage':'Electricity',
  'garbage':'Garbage','trash':'Garbage','waste':'Garbage','dump':'Garbage','dirty':'Garbage','smell':'Garbage',
};
document.addEventListener('input',e=>{
  if(e.target.id!=='description')return;
  const val=e.target.value.toLowerCase();
  let matched=null;
  for(const[kw,cat]of Object.entries(suggestionMap)){
    if(val.includes(kw)){matched=cat;break;}
  }
  if(matched){
    const radio=document.querySelector(`input[name="category"][value="${matched}"]`);
    if(radio&&!radio.checked){ radio.checked=true; showSmartHint(matched); }
  }
});
function showSmartHint(cat){
  let hint=document.getElementById('smart-hint');
  if(!hint){
    hint=document.createElement('div');
    hint.id='smart-hint';
    hint.style.cssText='background:var(--info-light);border:1px solid rgba(0,229,255,.2);border-left:3px solid var(--info);border-radius:6px;padding:.55rem .85rem;font-size:.78rem;color:var(--primary);margin-top:.5rem;animation:fadeInUp .25s ease both;';
    const desc=document.getElementById('description');
    if(desc)desc.parentElement.appendChild(hint);
  }
  hint.innerHTML=`🤖 Smart suggestion: Category auto-set to <strong>${cat}</strong> based on your description.`;
}

/* ══════════════════════════════════════
   8. GEOLOCATION
   ══════════════════════════════════════ */
document.addEventListener('click',e=>{
  const btn=e.target.closest('.geo-detect-btn');
  if(!btn)return;
  btn.disabled=true; btn.textContent='📍 Detecting...';
  if(!navigator.geolocation){ btn.textContent='📍 Not supported'; return; }
  navigator.geolocation.getCurrentPosition(pos=>{
    const{latitude:lat,longitude:lon}=pos.coords;
    fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`)
      .then(r=>r.json()).then(d=>{
        const loc=document.getElementById('location');
        if(loc&&d.display_name){ loc.value=d.display_name.split(',').slice(0,3).join(','); }
        btn.textContent='📍 Detected!'; btn.disabled=false;
      }).catch(()=>{ btn.textContent='📍 Detect Location'; btn.disabled=false; });
  },()=>{ btn.textContent='📍 Denied'; setTimeout(()=>{btn.textContent='📍 Detect Location';btn.disabled=false;},2000); });
});

/* ══════════════════════════════════════
   9. FILE UPLOAD UI (Visual Only)
   ══════════════════════════════════════ */
document.addEventListener('DOMContentLoaded',()=>{
  const uploadZone=document.querySelector('.upload-zone');
  if(!uploadZone)return;
  const previews=document.querySelector('.upload-previews');
  ['dragenter','dragover'].forEach(ev=>uploadZone.addEventListener(ev,e=>{e.preventDefault();uploadZone.classList.add('dragover');}));
  ['dragleave','drop'].forEach(ev=>uploadZone.addEventListener(ev,e=>{e.preventDefault();uploadZone.classList.remove('dragover');}));
  uploadZone.addEventListener('drop',e=>handleFiles(e.dataTransfer.files));
  uploadZone.addEventListener('click',()=>{
    const inp=document.createElement('input');inp.type='file';inp.multiple=true;inp.accept='image/*';
    inp.onchange=()=>handleFiles(inp.files); inp.click();
  });
  function handleFiles(files){
    if(!previews)return;
    Array.from(files).forEach(f=>{
      if(!f.type.startsWith('image/'))return;
      const reader=new FileReader();
      reader.onload=e=>{
        const div=document.createElement('div');div.className='upload-preview';
        div.innerHTML=`<img src="${e.target.result}"><button class="up-remove" onclick="this.parentElement.remove()">✕</button>`;
        previews.appendChild(div);
      };
      reader.readAsDataURL(f);
    });
  }
});

/* ══════════════════════════════════════
   10. COPY TO CLIPBOARD
   ══════════════════════════════════════ */
document.addEventListener('click',e=>{
  const btn=e.target.closest('.copy-btn');
  if(!btn)return;
  const text=btn.dataset.copy||btn.previousElementSibling?.textContent?.trim()||'';
  navigator.clipboard.writeText(text).then(()=>{
    btn.classList.add('copied');
    setTimeout(()=>btn.classList.remove('copied'),1500);
  });
});

/* ══════════════════════════════════════
   11. KEYBOARD SHORTCUTS MODAL
   ══════════════════════════════════════ */
function openShortcuts(){const m=document.querySelector('.shortcuts-modal');if(m)m.classList.add('open');}
function closeShortcuts(){document.querySelectorAll('.shortcuts-modal.open').forEach(m=>m.classList.remove('open'));}
document.addEventListener('click',e=>{
  if(e.target.closest('.shortcuts-modal')&&!e.target.closest('.shortcuts-box'))closeShortcuts();
});

/* ══════════════════════════════════════
   12. CALENDAR VIEW TOGGLE
   ══════════════════════════════════════ */
document.addEventListener('click',e=>{
  const btn=e.target.closest('.cal-btn');
  if(!btn)return;
  const wrap=btn.closest('.card')||btn.closest('.content-inner');
  btn.closest('.calendar-toggle').querySelectorAll('.cal-btn').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  const view=btn.dataset.view;
  const tableWrap=wrap.querySelector('.table-wrap');
  const calWrap=wrap.querySelector('.calendar-container');
  if(view==='calendar'){ if(tableWrap)tableWrap.style.display='none'; if(calWrap){calWrap.style.display='block';renderCalendar(calWrap,wrap);} }
  else{ if(tableWrap)tableWrap.style.display=''; if(calWrap)calWrap.style.display='none'; }
});
function renderCalendar(container,wrap){
  if(container.dataset.rendered)return;
  container.dataset.rendered='1';
  const now=new Date();const year=now.getFullYear();const month=now.getMonth();
  const firstDay=new Date(year,month,1).getDay();
  const daysInMonth=new Date(year,month+1,0).getDate();
  const days=['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  const monthNames=['January','February','March','April','May','June','July','August','September','October','November','December'];
  // Collect appointments from table
  const appts=[];
  const table=wrap.querySelector('.sc-table');
  if(table){
    table.querySelectorAll('tbody tr').forEach(row=>{
      const cells=row.querySelectorAll('td');
      cells.forEach(c=>{
        const text=c.textContent.trim();
        if(/^\d{4}-\d{2}-\d{2}$/.test(text)){
          const badge=row.querySelector('.badge');
          const status=badge?badge.textContent.trim().toLowerCase():'pending';
          appts.push({date:text,status});
        }
      });
    });
  }
  let html=`<div style="text-align:center;font-weight:700;margin-bottom:.75rem;font-size:.9rem;color:var(--text)">${monthNames[month]} ${year}</div>`;
  html+='<div class="calendar-grid">';
  days.forEach(d=>html+=`<div class="cal-header">${d}</div>`);
  for(let i=0;i<firstDay;i++) html+=`<div class="cal-day other-month"></div>`;
  for(let d=1;d<=daysInMonth;d++){
    const dateStr=`${year}-${String(month+1).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
    const isToday=d===now.getDate();
    const dayAppts=appts.filter(a=>a.date===dateStr);
    html+=`<div class="cal-day${isToday?' today':''}"><div class="day-num">${d}</div>`;
    dayAppts.forEach(a=>html+=`<span class="cal-dot ${a.status.includes('confirm')?'confirmed':a.status.includes('cancel')?'cancelled':'pending'}"></span>`);
    html+='</div>';
  }
  html+='</div>';
  container.innerHTML=html;
}

/* ══════════════════════════════════════
   13. GAMIFICATION BADGES
   ══════════════════════════════════════ */
function initGamification(){
  const container=document.getElementById('gamifBadges');
  if(!container)return;
  const badges=[
    {icon:'🏆',title:'Active Citizen',desc:'Filed 1+ complaints',check:()=>document.querySelectorAll('.qa-card').length>0},
    {icon:'🏥',title:'Health Conscious',desc:'Booked appointments',check:()=>true},
    {icon:'💰',title:'Bill Payer',desc:'Paid all bills on time',check:()=>true},
    {icon:'📢',title:'Informed Citizen',desc:'Reads announcements',check:()=>true},
    {icon:'⭐',title:'Top Contributor',desc:'10+ interactions',check:()=>false},
  ];
  container.innerHTML=badges.map(b=>{
    const unlocked=b.check();
    return`<div class="gamif-badge${unlocked?'':' locked'}"><div class="gamif-icon">${b.icon}</div><div class="gamif-title">${b.title}</div><div class="gamif-desc">${b.desc}</div></div>`;
  }).join('');
}
setTimeout(initGamification,300);

/* ══════════════════════════════════════
   14. BILL SUMMARY
   ══════════════════════════════════════ */
function initBillSummary(){
  const container=document.getElementById('billSummary');
  if(!container)return;
  const table=document.querySelector('.sc-table');
  if(!table)return;
  let totalDue=0,paidCount=0,unpaidCount=0;
  table.querySelectorAll('tbody tr').forEach(row=>{
    const badge=row.querySelector('.badge');
    const amountCell=Array.from(row.querySelectorAll('td')).find(c=>c.textContent.includes('₹'));
    const amount=amountCell?parseFloat(amountCell.textContent.replace(/[₹,]/g,'')):0;
    if(badge&&badge.textContent.trim()==='Unpaid'){unpaidCount++;totalDue+=amount;}
    else if(badge&&badge.textContent.trim()==='Paid'){paidCount++;}
  });
  container.innerHTML=`
    <div class="bill-sum-card"><div class="bill-sum-val" style="color:var(--danger)">₹${totalDue.toFixed(0)}</div><div class="bill-sum-lbl">Total Due</div></div>
    <div class="bill-sum-card"><div class="bill-sum-val" style="color:var(--success)">${paidCount}</div><div class="bill-sum-lbl">Bills Paid</div></div>
    <div class="bill-sum-card"><div class="bill-sum-val" style="color:var(--warning)">${unpaidCount}</div><div class="bill-sum-lbl">Unpaid</div></div>`;
}
setTimeout(initBillSummary,300);

/* ══════════════════════════════════════
   15. SKELETON LOADING
   ══════════════════════════════════════ */
document.addEventListener('DOMContentLoaded',()=>{
  document.querySelectorAll('.skeleton-wrap').forEach(el=>{
    setTimeout(()=>{el.style.display='none';const next=el.nextElementSibling;if(next)next.style.display='';},600);
  });
});

})();
