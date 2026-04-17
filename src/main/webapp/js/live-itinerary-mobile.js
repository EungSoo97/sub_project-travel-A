// Mobile-optimized daily itinerary functionality

// Function to create mobile-optimized daily itinerary
function createMobileItinerary(planDetail) {
    console.log('createMobileItinerary called with:', planDetail);
    console.log('This function is disabled in favor of the new modal UI.');
    return;
    
    if (!planDetail || !planDetail.itinerary) {
        console.log('No itinerary data available');
        return;
    }
    
    console.log('Creating itinerary container...');
    
    // Create itinerary container
    const container = document.createElement('div');
    container.className = 'itinerary-container';
    
    // Create header
    const header = document.createElement('div');
    header.className = 'itinerary-header';
    header.innerHTML = `
        <h3>daily schedule</h3>
        <button class="toggle-all-btn" onclick="toggleAllDays()">expand all</button>
    `;
    
    // Create days list
    const daysList = document.createElement('div');
    daysList.className = 'days-list';
    
    // Create day items
    planDetail.itinerary.forEach((dayItem, index) => {
        const dayNum = index + 1;
        const dayItemEl = document.createElement('div');
        dayItemEl.className = 'day-item';
        dayItemEl.setAttribute('data-day', dayNum);
        
        // Create day toggle
        const dayToggle = document.createElement('div');
        dayToggle.className = 'day-toggle';
        dayToggle.onclick = () => toggleDay(dayNum);
        dayToggle.innerHTML = `
            <div class="day-info">
                <span class="day-badge">day ${dayNum}</span>
                <span class="day-title">${dayNum}st day</span>
            </div>
            <span class="toggle-icon">></span>
        `;
        
        // Create day content
        const dayContent = document.createElement('div');
        dayContent.className = 'day-content';
        dayContent.id = `day-${dayNum}`;
        dayContent.style.display = 'none';
        
        // Add activities
        if (dayItem.activities) {
            dayItem.activities.forEach(activity => {
                const activityItem = document.createElement('div');
                activityItem.className = 'activity-item';
                activityItem.innerHTML = `
                    <div class="activity-time">${activity.time || ''}</div>
                    <div class="activity-details">
                        <h4>${activity.name || ''}</h4>
                        <p>${activity.description || ''}</p>
                    </div>
                `;
                dayContent.appendChild(activityItem);
            });
        }
        
        dayItemEl.appendChild(dayToggle);
        dayItemEl.appendChild(dayContent);
        daysList.appendChild(dayItemEl);
    });
    
    container.appendChild(header);
    container.appendChild(daysList);
    
    // Add to page after live-header and before realtime-box
    console.log('Looking for live-header...');
    const liveHeader = document.querySelector('.live-header');
    const realtimeBox = document.querySelector('.realtime-box');
    
    if (liveHeader && liveHeader.parentNode) {
        console.log('Found live-header, inserting after it...');
        liveHeader.parentNode.insertBefore(container, realtimeBox);
        console.log('Container inserted after live-header');
    } else {
        console.log('No live-header found, trying fallback...');
        const livePage = document.querySelector('.live-page');
        if (livePage) {
            livePage.appendChild(container);
            console.log('Container appended to live-page');
        } else {
            document.body.appendChild(container);
            console.log('Container appended to body as fallback');
        }
    }
    
    // Load CSS
    console.log('Loading CSS...');
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = window.LIVE_CTX + '/css/live-itinerary-mobile.css';
    document.head.appendChild(link);
    console.log('CSS loaded');
}

// Toggle individual day
function toggleDay(dayNum) {
    const dayContent = document.getElementById(`day-${dayNum}`);
    const dayItem = document.querySelector(`[data-day="${dayNum}"]`);
    const toggleIcon = dayItem.querySelector('.toggle-icon');
    
    if (!dayContent || !dayItem || !toggleIcon) {
        console.log(`toggleDay: day-${dayNum} element not found`);
        return;
    }
    
    if (dayContent.style.display === 'none') {
        dayContent.style.display = 'block';
        dayItem.classList.add('expanded');
        toggleIcon.textContent = 'v';
    } else {
        dayContent.style.display = 'none';
        dayItem.classList.remove('expanded');
        toggleIcon.textContent = '>';
    }
}

// Toggle all days
function toggleAllDays() {
    const allDayContents = document.querySelectorAll('.day-content');
    const allDayItems = document.querySelectorAll('.day-item');
    const allToggleIcons = document.querySelectorAll('.toggle-icon');
    const toggleBtn = document.querySelector('.toggle-all-btn');
    
    if (!allDayContents.length || !allDayItems.length || !toggleBtn) {
        console.log('toggleAllDays: elements not found');
        return;
    }
    
    const isExpanded = allDayItems[0].classList.contains('expanded');
    
    if (isExpanded) {
        // Collapse all
        allDayContents.forEach(content => {
            content.style.display = 'none';
        });
        allDayItems.forEach(item => {
            item.classList.remove('expanded');
        });
        allToggleIcons.forEach(icon => {
            icon.textContent = '>';
        });
        toggleBtn.textContent = 'expand all';
    } else {
        // Expand all
        allDayContents.forEach(content => {
            content.style.display = 'block';
        });
        allDayItems.forEach(item => {
            item.classList.add('expanded');
        });
        allToggleIcons.forEach(icon => {
            icon.textContent = 'v';
        });
        toggleBtn.textContent = 'collapse all';
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('Mobile itinerary script loaded');
    console.log('window.PLAN_DETAIL available:', !!window.PLAN_DETAIL);
    console.log('window.LIVE_PLAN_ID:', window.LIVE_PLAN_ID);
    
    // Wait for plan data to be available
    setTimeout(function() {
        console.log('setTimeout executed in mobile itinerary');
        
        // Try to get plan data from window or create demo data
        let planDetail = window.PLAN_DETAIL;
        
        if (!planDetail) {
            console.log('No planDetail found, creating demo data');
            // Create demo data for testing
            planDetail = {
                itinerary: [
                    {
                        day: 1,
                        activities: [
                            { time: '09:00', name: 'Airport Check-in', description: 'Check-in and security' },
                            { time: '12:00', name: 'Lunch', description: 'Airport restaurant' },
                            { time: '15:00', name: 'Boarding', description: 'Flight departure' }
                        ]
                    },
                    {
                        day: 2,
                        activities: [
                            { time: '08:00', name: 'Breakfast', description: 'Hotel breakfast' },
                            { time: '10:00', name: 'City Tour', description: 'Guided city tour' },
                            { time: '18:00', name: 'Dinner', description: 'Local restaurant' }
                        ]
                    }
                ]
            };
        } else {
            console.log('Found planDetail:', planDetail);
        }
        
        console.log('About to create mobile itinerary');
        createMobileItinerary(planDetail);
        console.log('Mobile itinerary creation completed');
    }, 200);
});
