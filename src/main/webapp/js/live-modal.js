// Bottom slide-up modal for daily itinerary

let modalOverlay = null;
let modalContent = null;
let modalTitle = null;
let currentPlanData = null;

// Initialize modal
function initModal() {
    console.log('Initializing modal...');
    
    // Check if modal already exists
    if (modalOverlay) {
        console.log('Modal already exists, removing old one...');
        modalOverlay.remove();
    }
    
    // Create modal elements
    modalOverlay = document.createElement('div');
    modalOverlay.className = 'schedule-modal-overlay';
    modalOverlay.id = 'schedule-modal-overlay';
    
    const modal = document.createElement('div');
    modal.className = 'schedule-modal';
    modal.id = 'schedule-modal';
    
    const modalHeader = document.createElement('div');
    modalHeader.className = 'modal-header';
    
    modalTitle = document.createElement('h3');
    modalTitle.className = 'modal-title';
    
    const modalClose = document.createElement('button');
    modalClose.className = 'modal-close';
    modalClose.innerHTML = '×';
    modalClose.onclick = closeModal;
    
    modalContent = document.createElement('div');
    modalContent.className = 'modal-content';
    modalContent.style.cssText = `
        overflow-y: auto;
        max-height: 80vh;
        padding-bottom: 20px;
        box-sizing: border-box;
    `;
    
    modalHeader.appendChild(modalTitle);
    modalHeader.appendChild(modalClose);
    modal.appendChild(modalHeader);
    modal.appendChild(modalContent);
    modalOverlay.appendChild(modal);
    
    // Add to body with forced styles
    document.body.appendChild(modalOverlay);
    
    // Force initial styles
    modalOverlay.style.cssText = `
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        height: 100% !important;
        background: rgba(0, 0, 0, 0.7) !important;
        z-index: 99999 !important;
        opacity: 0 !important;
        visibility: hidden !important;
        transition: opacity 0.3s ease, visibility 0.3s ease !important;
        pointer-events: none !important;
    `;
    
    modal.style.cssText = `
        position: fixed !important;
        bottom: 0 !important;
        left: 0 !important;
        width: 100% !important;
        max-height: 80vh !important;
        background: white !important;
        border-radius: 0 !important;
        box-shadow: none !important;
        transform: translateY(100%) !important;
        transition: transform 0.3s ease !important;
        overflow: hidden !important;
        z-index: 100000 !important;
        pointer-events: auto !important;
    `;
    
    console.log('Modal initialized successfully');
    
    // Close modal when clicking overlay
    modalOverlay.addEventListener('click', function(e) {
        if (e.target === modalOverlay) {
            closeModal();
        }
    });
    
    // Prevent clicks inside modal from closing it
    modal.addEventListener('click', function(e) {
        e.stopPropagation();
    });
    
    // Close modal with ESC key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && modalOverlay.classList.contains('active')) {
            closeModal();
        }
    });
}

// Open modal with specific day data
function openModal(dayIndex, planData) {
    if (!modalOverlay) {
        initModal();
    }
    
    currentPlanData = planData;
    
    console.log('Opening modal for day index:', dayIndex);
    console.log('Plan data:', planData);
    console.log('Itinerary:', planData.itinerary);
    
    // Get day data - handle different data structures
    let dayData = null;
    
    console.log('Looking for day index:', dayIndex);
    console.log('Available itinerary keys:', Object.keys(planData.itinerary || {}));
    
    if (planData.itinerary) {
        // Try array access first
        if (Array.isArray(planData.itinerary)) {
            dayData = planData.itinerary[dayIndex];
            console.log('Found using array access:', dayData);
        }
        
        // Try object access with different key formats
        if (!dayData) {
            const possibleKeys = [
                `day${dayIndex + 1}`,
                `Day${dayIndex + 1}`,
                `day${dayIndex}`,
                `Day${dayIndex}`,
                `${dayIndex + 1}`,
                `${dayIndex}`
            ];
            
            for (const key of possibleKeys) {
                if (planData.itinerary[key]) {
                    dayData = planData.itinerary[key];
                    console.log(`Found using key "${key}":`, dayData);
                    break;
                }
            }
        }
        
        // Try to find day data by matching day number
        if (!dayData) {
            for (const [key, value] of Object.entries(planData.itinerary)) {
                if (value && (value.day === dayIndex + 1 || value.day === dayIndex)) {
                    dayData = value;
                    console.log(`Found by day number matching key "${key}":`, dayData);
                    break;
                }
            }
        }
    }
    
    if (!dayData) {
        console.error('Day data not found for index:', dayIndex);
        console.error('Available itinerary data:', Object.keys(planData.itinerary || {}));
        
        // Check if we have real day data from the page
        const realDayData = getRealDayData(dayIndex);
        
        if (realDayData.activities.length > 0) {
            // Use real data from page instead
            console.log('Using real data from page for day:', dayIndex);
            
            // Clear content first
            modalContent.innerHTML = '';
            createDetailedModalContent(realDayData, dayIndex, modalContent);
            
            // Show modal with forced styles
            modalOverlay.classList.add('active');
            modalOverlay.style.pointerEvents = 'auto';
            modalOverlay.style.opacity = '1';
            modalOverlay.style.visibility = 'visible';
            
            // Show modal content
            const modal = modalOverlay.querySelector('.schedule-modal');
            if (modal) {
                modal.style.transform = 'translateY(0)';
            }
            
            document.body.style.overflow = 'hidden';
            return;
        } else {
            // Create empty state with proper message
            modalTitle.textContent = `Day ${dayIndex + 1} - No Schedule`;
            modalContent.innerHTML = `
                <div class="modal-empty">
                    <div class="modal-empty-icon">Calendar</div>
                    <div>No schedule available for Day ${dayIndex + 1}</div>
                </div>
            `;
            
            // Show modal anyway
            modalOverlay.classList.add('active');
            document.body.style.overflow = 'hidden';
            return;
        }
    }
    
    console.log('Day data found:', dayData);
    
    // Use real data from page instead of original dayData
    const realDayData = getRealDayData(dayIndex);
    console.log('Using real data for modal display');
    
    // Set title
    modalTitle.textContent = `Day ${dayIndex + 1} - ${realDayData.title || 'Daily Schedule'}`;
    
    // Clear content
    modalContent.innerHTML = '';
    
    // Create detailed modal content with real data
    createDetailedModalContent(realDayData, dayIndex, modalContent);
    
    // Show modal
    modalOverlay.classList.add('active');
    modalOverlay.style.pointerEvents = 'auto';
    modalOverlay.style.opacity = '1';
    modalOverlay.style.visibility = 'visible';
    
    // Show modal content
    const modal = modalOverlay.querySelector('.schedule-modal');
    if (modal) {
        modal.style.transform = 'translateY(0)';
    }
    
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

// Close modal
function closeModal() {
    console.log('Closing modal...');
    
    if (modalOverlay) {
        console.log('Modal overlay found, removing active class');
        modalOverlay.classList.remove('active');
        
        // Force hide styles
        modalOverlay.style.opacity = '0';
        modalOverlay.style.visibility = 'hidden';
        modalOverlay.style.pointerEvents = 'none';
        
        // Hide modal content
        const modal = modalOverlay.querySelector('.schedule-modal');
        if (modal) {
            modal.style.transform = 'translateY(100%)';
        }
        
        document.body.style.overflow = ''; // Restore scrolling
        
        console.log('Modal closed successfully');
    } else {
        console.log('No modal overlay found to close');
    }
}

// Get real day data from the myLive.jsp page
function getRealDayData(dayIndex) {
    console.log('Getting real data for day index:', dayIndex);
    
    // Use window.PLAN_DETAIL from JSP (DB data)
    if (window.PLAN_DETAIL && window.PLAN_DETAIL.itinerary && window.PLAN_DETAIL.itinerary.length > dayIndex) {
        const dayData = window.PLAN_DETAIL.itinerary[dayIndex];
        console.log('Found DB day data:', dayData);
        
        // Format the data to match expected structure
        const formattedDayData = {
            title: `Day ${dayData.day}`,
            date: dayData.date,
            distance: 'No data', // Not available in DB structure
            duration: 'No data', // Not available in DB structure
            activities: dayData.activities || []
        };
        
        console.log('Formatted day data:', formattedDayData);
        return formattedDayData;
    }
    
    // Fallback to DOM parsing if no DB data found
    console.log('No DB data found, falling back to DOM parsing');
    
    // Find the day card for the given index
    const dayCards = document.querySelectorAll('.day-card');
    console.log('Total day cards found:', dayCards.length);
    
    const dayCard = dayCards[dayIndex];
    
    if (!dayCard) {
        console.log('Day card not found for index:', dayIndex);
        console.log('Available indices:', Array.from({length: dayCards.length}, (_, i) => i));
        
        // Return empty data for missing day
        return {
            title: `Day ${dayIndex + 1}`,
            date: new Date().toLocaleDateString('ko-KR'),
            distance: 'No data',
            duration: 'No data',
            activities: [],
            estimatedCost: '¥0'
        };
    }
    
    console.log('Found day card:', dayCard);
    
    // Extract data from the day card
    const dayData = {
        title: `Day ${dayIndex + 1}`,
        date: dayCard.querySelector('.day-date')?.textContent || new Date().toLocaleDateString('ko-KR'),
        distance: dayCard.querySelector('.distance')?.textContent?.trim() || 'No distance info',
        duration: dayCard.querySelector('.transport')?.textContent?.trim() || 'No transport info',
        activities: []
    };
    
    // Extract activities from the day card
    const scheduleItems = dayCard.querySelectorAll('.schedule-item');
    console.log('Found schedule items:', scheduleItems.length);
    
    scheduleItems.forEach((item, index) => {
        const activity = {
            time: item.querySelector('.time')?.textContent || '',
            name: item.querySelector('.title')?.textContent || '',
            description: item.querySelector('.desc')?.textContent || '',
            duration: item.querySelector('.meta span:first-child')?.textContent || '',
            cost: item.querySelector('.meta span:last-child')?.textContent || '',
            category: item.dataset.category || '',
            lat: item.dataset.lat || '',
            lng: item.dataset.lng || ''
        };
        
        dayData.activities.push(activity);
        console.log(`Activity ${index + 1}:`, activity);
    });
    
    // Extract footer summary if available
    const dayFooter = dayCard.querySelector('.day-footer');
    if (dayFooter) {
        const footerText = dayFooter.textContent;
        console.log('Day footer:', footerText);
        
        // Extract estimated cost from footer
        const costMatch = footerText.match(/(\d+(?:,\d+)*)\s*(\w+)/);
        if (costMatch) {
            dayData.estimatedCost = costMatch[1] + ' ' + costMatch[2];
        }
    }
    
    console.log('Final day data:', dayData);
    return dayData;
}

// Create single unified modal content - no nested sections
function createDetailedModalContent(dayData, dayIndex, modalContent) {
    // Get real data from the page
    const realDayData = getRealDayData(dayIndex);
    
    // Create single unified container
    const unifiedContent = document.createElement('div');
    unifiedContent.className = 'unified-modal-content';
    unifiedContent.style.cssText = `
        background: white;
        padding: 0;
        border-radius: 0;
        overflow: hidden;
    `;
    
    // Create header section
    const headerSection = document.createElement('div');
    headerSection.style.cssText = `
        background: transparent;
        padding: 20px;
        border: none;
        text-align: center;
    `;
    
    const titleElement = document.createElement('h3');
    titleElement.style.cssText = `
        font-size: 18px;
        font-weight: 700;
        color: #333;
        margin: 0 0 12px 0;
    `;
    titleElement.textContent = `${dayIndex + 1}Day - ${realDayData.title || 'Daily Schedule'}`;
    
    const infoContainer = document.createElement('div');
    infoContainer.style.cssText = `
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        justify-content: center;
    `;
    
    const dateInfo = document.createElement('div');
    dateInfo.style.cssText = `
        font-size: 14px;
        color: #666;
        font-weight: 500;
    `;
    dateInfo.textContent = realDayData.date || new Date().toLocaleDateString('ko-KR');
    
    const distanceInfo = document.createElement('div');
    distanceInfo.style.cssText = `
        font-size: 14px;
        color: #666;
        font-weight: 500;
    `;
    distanceInfo.textContent = realDayData.distance || 'No distance info';
    
    const durationInfo = document.createElement('div');
    durationInfo.style.cssText = `
        font-size: 14px;
        color: #666;
        font-weight: 500;
    `;
    durationInfo.textContent = realDayData.duration || 'No duration info';
    
    infoContainer.appendChild(dateInfo);
    infoContainer.appendChild(distanceInfo);
    infoContainer.appendChild(durationInfo);
    
    headerSection.appendChild(titleElement);
    headerSection.appendChild(infoContainer);
    
    // Create activities section
    const activitiesSection = document.createElement('div');
    activitiesSection.style.cssText = `
        background: transparent;
        padding: 0;
        max-height: none;
        overflow: visible;
    `;
    
    const activitiesHeader = document.createElement('div');
    activitiesHeader.style.cssText = `
        background: transparent;
        padding: 15px 20px;
        border: none;
        font-size: 16px;
        font-weight: 600;
        color: #333;
    `;
    activitiesHeader.textContent = 'Daily Schedule';
    
    const activitiesList = document.createElement('div');
    activitiesList.style.cssText = `
        padding: 0;
    `;
    
    // Use real activities from the page
    const realActivities = realDayData.activities;
    
    if (realActivities.length > 0) {
        realActivities.forEach((activity, index) => {
            const activityItem = document.createElement('div');
            activityItem.style.cssText = `
                display: flex;
                padding: 20px;
                border: none;
                transition: background-color 0.2s ease;
                background: transparent;
            `;
            
            const timeElement = document.createElement('div');
            timeElement.style.cssText = `
                min-width: 80px;
                font-size: 13px;
                font-weight: 600;
                color: #378ADD;
                flex-shrink: 0;
            `;
            timeElement.textContent = activity.time || '';
            
            const contentElement = document.createElement('div');
            contentElement.style.cssText = `
                flex: 1;
                margin: 0 16px;
            `;
            
            const activityTitle = document.createElement('h4');
            activityTitle.style.cssText = `
                margin: 0 0 4px 0;
                font-size: 15px;
                font-weight: 600;
                color: #333;
            `;
            activityTitle.textContent = activity.name || '';
            
            const activityDesc = document.createElement('p');
            activityDesc.style.cssText = `
                margin: 0;
                font-size: 13px;
                color: #666;
                line-height: 1.4;
            `;
            activityDesc.textContent = activity.description || '';
            
            contentElement.appendChild(activityTitle);
            contentElement.appendChild(activityDesc);
            
            const costElement = document.createElement('div');
            costElement.style.cssText = `
                min-width: 80px;
                text-align: right;
                font-size: 14px;
                font-weight: 600;
                color: #e91e63;
                flex-shrink: 0;
            `;
            costElement.textContent = activity.cost || '';
            
            activityItem.appendChild(timeElement);
            activityItem.appendChild(contentElement);
            activityItem.appendChild(costElement);
            
            // Add click event to show real-time location data
            activityItem.style.cursor = 'pointer';
            activityItem.onclick = function() {
                // Add dayIndex to activity object
                const activityWithDayIndex = {
                    ...activity,
                    dayIndex: dayIndex
                };
                showLocationRealtimeData(activityWithDayIndex);
            };
            
            activitiesList.appendChild(activityItem);
        });
    } else {
        const emptyItem = document.createElement('div');
        emptyItem.style.cssText = `
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 16px;
        `;
        emptyItem.textContent = 'No activities scheduled';
        activitiesList.appendChild(emptyItem);
    }
    
    activitiesSection.appendChild(activitiesHeader);
    activitiesSection.appendChild(activitiesList);
    
    // Create cost summary section
    const costSection = document.createElement('div');
    costSection.style.cssText = `
        background: transparent;
        padding: 20px;
        border: none;
    `;
    
    const costTitle = document.createElement('h3');
    costTitle.style.cssText = `
        font-size: 16px;
        font-weight: 700;
        color: #333;
        margin: 0 0 12px 0;
    `;
    costTitle.textContent = 'Cost Summary';
    
    // Calculate costs
    let totalCost = 0;
    let transportCost = 0;
    let foodCost = 0;
    let otherCost = 0;
    
    realActivities.forEach(activity => {
        const costText = activity.cost || '0';
        const costValue = parseInt(costText.replace(/[^\d]/g, '')) || 0;
        totalCost += costValue;
        
        if (activity.category === 'TRANSPORT' || activity.category === 'MOVE') {
            transportCost += costValue;
        } else if (activity.category === 'DINING' || activity.category === 'FOOD' || activity.category === 'RESTAURANT') {
            foodCost += costValue;
        } else {
            otherCost += costValue;
        }
    });
    
    // Create cost items
    const costItems = [
        { label: 'Transportation', value: transportCost > 0 ? `¥${transportCost.toLocaleString()}` : 'Free' },
        { label: 'Food & Dining', value: foodCost > 0 ? `¥${foodCost.toLocaleString()}` : 'Free' },
        { label: 'Activities', value: otherCost > 0 ? `¥${otherCost.toLocaleString()}` : 'Free' },
        { label: 'Total Cost', value: `¥${totalCost.toLocaleString()}`, isTotal: true }
    ];
    
    costItems.forEach(item => {
        const costItem = document.createElement('div');
        costItem.style.cssText = `
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        `;
        
        if (item.isTotal) {
            costItem.style.borderBottom = 'none';
            costItem.style.marginTop = '8px';
            costItem.style.paddingTop = '16px';
            costItem.style.borderTop = '1px solid #f0f0f0';
        }
        
        const label = document.createElement('span');
        label.style.cssText = `
            font-size: 14px;
            color: ${item.isTotal ? '#333' : '#666'};
            font-weight: ${item.isTotal ? '700' : '500'};
        `;
        label.textContent = item.label;
        
        const value = document.createElement('span');
        value.style.cssText = `
            font-size: ${item.isTotal ? '18px' : '16px'};
            font-weight: ${item.isTotal ? '800' : '700'};
            color: #333;
        `;
        value.textContent = item.value;
        
        costItem.appendChild(label);
        costItem.appendChild(value);
        costSection.appendChild(costItem);
    });
    
    // Assemble unified content
    unifiedContent.appendChild(headerSection);
    unifiedContent.appendChild(activitiesSection);
    unifiedContent.appendChild(costSection);
    
    // Clear and add to modal content
    modalContent.innerHTML = '';
    modalContent.appendChild(unifiedContent);
}

// Create activity element for modal (legacy function)
function createActivityElement(activity) {
    const activityElement = document.createElement('div');
    activityElement.className = 'activity-item';
    
    const timeElement = document.createElement('div');
    timeElement.className = 'activity-time';
    timeElement.textContent = activity.time || '';
    
    const detailsElement = document.createElement('div');
    detailsElement.className = 'activity-details';
    
    const titleElement = document.createElement('h4');
    titleElement.textContent = activity.name || '';
    
    const descriptionElement = document.createElement('p');
    descriptionElement.textContent = activity.description || '';
    
    detailsElement.appendChild(titleElement);
    detailsElement.appendChild(descriptionElement);
    
    activityElement.appendChild(timeElement);
    activityElement.appendChild(detailsElement);
    
    return activityElement;
}

// Create day click buttons for existing itinerary
function createDayClickButtons(planData) {
    if (!planData || !planData.itinerary) return;
    
    console.log('Creating day click buttons for planData:', planData);
    
    // Use actual day cards instead of day headers
    const dayCards = document.querySelectorAll('.day-card');
    console.log('Found day cards:', dayCards.length);
    
    dayCards.forEach((dayCard, index) => {
        // Find the header within this day card
        const dayHeader = dayCard.querySelector('.day-header');
        if (!dayHeader) {
            console.log('No header found for day card:', index);
            return;
        }
        
        // Check if button already exists
        if (dayHeader.querySelector('.day-click-btn')) {
            console.log('Button already exists for day:', index);
            return;
        }
        
        console.log('Adding button to header:', dayHeader, 'index:', index);
        
        // Create click button
        const clickBtn = document.createElement('button');
        clickBtn.className = 'day-click-btn';
        clickBtn.innerHTML = 'View Details';
        clickBtn.onclick = function() {
            openModal(index, planData);
        };
        
        // Style the button
        clickBtn.style.cssText = `
            background: #378ADD;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            margin-left: 10px;
            transition: all 0.2s ease;
        `;
        
        clickBtn.onmouseover = function() {
            this.style.background = '#2c6bb0';
            this.style.transform = 'translateY(-1px)';
        };
        
        clickBtn.onmouseout = function() {
            this.style.background = '#378ADD';
            this.style.transform = 'translateY(0)';
        };
        
        // Add to header
        dayHeader.appendChild(clickBtn);
    });
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('Live modal script loaded');
    
    // Wait for plan data and itinerary to be available
    setTimeout(function() {
        console.log('Checking for plan data...');
        const planData = window.PLAN_DETAIL;
        console.log('Plan data available:', !!planData);
        
        if (planData) {
            console.log('Plan data found:', planData);
            // Wait a bit more for itinerary to be created
            setTimeout(function() {
                console.log('Creating day click buttons...');
                createDayClickButtons(planData);
                
                // Also try to create buttons directly from DOM if plan data doesn't work
                setTimeout(function() {
                    console.log('Checking for day cards directly...');
                    const dayCards = document.querySelectorAll('.day-card');
                    console.log('Found day cards:', dayCards.length);
                    
                    if (dayCards.length > 0) {
                        // Create buttons for each day card regardless of plan data
                        dayCards.forEach((dayCard, index) => {
                            const dayHeader = dayCard.querySelector('.day-header');
                            if (dayHeader && !dayHeader.querySelector('.day-click-btn')) {
                                console.log('Creating button for day card:', index);
                                
                                const clickBtn = document.createElement('button');
                                clickBtn.className = 'day-click-btn';
                                clickBtn.innerHTML = 'View Details';
                                clickBtn.onclick = function() {
                                    console.log('Button clicked for day:', index);
                                    openModal(index, planData);
                                };
                                
                                clickBtn.style.cssText = `
                                    background: #378ADD;
                                    color: white;
                                    border: none;
                                    padding: 6px 12px;
                                    border-radius: 6px;
                                    font-size: 12px;
                                    cursor: pointer;
                                    margin-left: 10px;
                                    transition: all 0.2s ease;
                                `;
                                
                                clickBtn.onmouseover = function() {
                                    this.style.background = '#2c6bb0';
                                    this.style.transform = 'translateY(-1px)';
                                };
                                
                                clickBtn.onmouseout = function() {
                                    this.style.background = '#378ADD';
                                    this.style.transform = 'translateY(0)';
                                };
                                
                                dayHeader.appendChild(clickBtn);
                            }
                        });
                    }
                }, 500);
            }, 1000);
        } else {
            console.log('No plan data found, trying demo data...');
            // Try to create demo data for testing
            const demoData = {
                itinerary: [
                    {
                        day: 1,
                        title: 'Day 1',
                        activities: [
                            { time: '09:00', name: 'Airport Check-in', description: 'Check-in and security' },
                            { time: '12:00', name: 'Lunch', description: 'Airport restaurant' },
                            { time: '15:00', name: 'Boarding', description: 'Flight departure' }
                        ]
                    },
                    {
                        day: 2,
                        title: 'Day 2',
                        activities: [
                            { time: '08:00', name: 'Breakfast', description: 'Hotel breakfast' },
                            { time: '10:00', name: 'City Tour', description: 'Guided city tour' },
                            { time: '18:00', name: 'Dinner', description: 'Local restaurant' }
                        ]
                    }
                ]
            };
            createDayClickButtons(demoData);
        }
    }, 500);
});

// Show location name and times in main live card
function showLocationRealtimeData(activity) {
    console.log('Showing location:', activity);
    
    // Update main live card with location name and times
    const titleElement = document.getElementById('liveActivityTitle');
    const startElement = document.getElementById('liveActivityStart');
    const endElement = document.getElementById('liveActivityEnd');
    
    // Set location name
    if (titleElement) {
        titleElement.textContent = activity.name || 'Loading...';
    }
    
    // Set start time from clicked activity
    if (startElement) {
        startElement.textContent = activity.time || '-';
    }
    
    // Set end time from next activity
    if (endElement) {
        const nextActivityTime = getNextActivityTime(activity);
        endElement.textContent = nextActivityTime || '-';
    }
    
    // Update next schedule information
    updateNextScheduleInfo(activity);
    
    // Close modal after selection
    closeModal();
}

// Get next activity time
function getNextActivityTime(currentActivity) {
    console.log('Getting next activity time for:', currentActivity);
    
    // Get all activities from the current day
    const dayData = getRealDayData(currentActivity.dayIndex);
    const activities = dayData.activities || [];
    
    console.log('Day data:', dayData);
    console.log('Activities:', activities);
    
    // Find current activity index
    const currentIndex = activities.findIndex(act => 
        act.time === currentActivity.time && act.name === currentActivity.name
    );
    
    console.log('Current activity index:', currentIndex);
    
    // If next activity exists, return its time
    if (currentIndex !== -1 && currentIndex < activities.length - 1) {
        const nextActivity = activities[currentIndex + 1];
        console.log('Next activity found:', nextActivity);
        return nextActivity.time;
    }
    
    // No next activity found
    console.log('No next activity found');
    return null;
}

// Update next schedule information
function updateNextScheduleInfo(currentActivity) {
    console.log('Updating next schedule info for:', currentActivity);
    
    // Get all activities from the current day
    const dayData = getRealDayData(currentActivity.dayIndex);
    const activities = dayData.activities || [];
    
    // Find current activity index
    const currentIndex = activities.findIndex(act => 
        act.time === currentActivity.time && act.name === currentActivity.name
    );
    
    // Get next schedule elements
    const nextTitleElement = document.getElementById('liveNextTitle');
    const nextSummaryElement = document.getElementById('liveNextSummary');
    
    // Reset to default values
    if (nextTitleElement) nextTitleElement.textContent = '-';
    if (nextSummaryElement) nextSummaryElement.textContent = '-';
    
    // If next activity exists, update the information
    if (currentIndex !== -1 && currentIndex < activities.length - 1) {
        const nextActivity = activities[currentIndex + 1];
        console.log('Next activity found:', nextActivity);
        
        // Update next title
        if (nextTitleElement && nextActivity.name) {
            nextTitleElement.textContent = nextActivity.name;
        }
        
        // Format summary: time · distance · duration
        if (nextSummaryElement) {
            const time = nextActivity.time || '-';
            const distance = nextActivity.distance || '1.2km'; // Default distance
            const duration = nextActivity.durationMinutes || '15분'; // Default duration
            
            // Format: "17:00 예정 · 1.2km · 15분"
            const summary = `${time} 예정 · ${distance} · ${duration}`;
            nextSummaryElement.textContent = summary;
        }
    } else {
        console.log('No next activity found for schedule info');
    }
}

// --- New Full Schedule Accordion UI ---
function openFullScheduleModal() {
    if (!modalOverlay) {
        initModal();
    }
    
    // Set up modal header
    let planDetail = window.PLAN_DETAIL;
    if (!planDetail || !planDetail.itinerary) {
        // Fallback or demo data if needed. Usually myLive exposes PLAN_DETAIL.
        console.error('No plan detail found. Trying to parse from DOM but PLAN_DETAIL is expected.');
        return;
    }

    modalContent.innerHTML = '';
    
    const headerTop = document.createElement('div');
    headerTop.className = 'fs-modal-header-top';
    headerTop.innerHTML = `
        <h3 class="fs-modal-title">daily schedule</h3>
        <button class="fs-expand-btn" onclick="toggleAllFsDays()">expand all</button>
    `;
    modalContent.appendChild(headerTop);

    const accordionContainer = document.createElement('div');
    accordionContainer.style.paddingBottom = '30px'; // Extra padding for better scrolling
    
    planDetail.itinerary.forEach((dayData, index) => {
        const dayItem = document.createElement('div');
        dayItem.className = 'fs-day-item';
        dayItem.dataset.day = index;

        const dayToggle = document.createElement('div');
        dayToggle.className = 'fs-day-toggle';
        dayToggle.onclick = function() { toggleFsDay(index); };
        
        dayToggle.innerHTML = `
            <div class="fs-day-info">
                <div class="fs-day-circle">
                    <span>day</span>
                    <span>${index + 1}</span>
                </div>
                <span class="fs-day-title">${index + 1}${index === 0 ? 'st' : index === 1 ? 'nd' : index === 2 ? 'rd' : 'th'} day</span>
            </div>
            <div class="fs-toggle-icon">&gt;</div>
        `;

        const dayContent = document.createElement('div');
        dayContent.className = 'fs-day-content';
        dayContent.id = 'fs-day-content-' + index;

        if (dayData.activities && dayData.activities.length > 0) {
            dayData.activities.forEach(act => {
                const actItem = document.createElement('div');
                actItem.className = 'fs-activity-item';
                actItem.onclick = function() {
                    const activityWithDayIndex = { ...act, dayIndex: index };
                    // Leverage existing function to update dash
                    showLocationRealtimeData(activityWithDayIndex);
                };

                actItem.innerHTML = `
                    <div class="fs-activity-time">${act.time || ''}</div>
                    <div class="fs-activity-details">
                        <h4>${act.name || ''}</h4>
                        <p>${act.description || ''}</p>
                    </div>
                `;
                dayContent.appendChild(actItem);
            });
        } else {
            const emptyAct = document.createElement('div');
            emptyAct.style.cssText = 'padding: 16px 20px; color: #94a3b8; font-size: 13px; text-align: center;';
            emptyAct.textContent = '아직 등록된 일정이 없습니다.';
            dayContent.appendChild(emptyAct);
        }

        dayItem.appendChild(dayToggle);
        dayItem.appendChild(dayContent);
        accordionContainer.appendChild(dayItem);
    });

    modalContent.appendChild(accordionContainer);
    
    // Hide default modal title
    if (modalTitle) modalTitle.textContent = ''; 

    modalOverlay.classList.add('active');
    modalOverlay.style.pointerEvents = 'auto';
    modalOverlay.style.opacity = '1';
    modalOverlay.style.visibility = 'visible';
    
    const modal = modalOverlay.querySelector('.schedule-modal');
    if (modal) {
        modal.style.transform = 'translateY(0)';
    }
    document.body.style.overflow = 'hidden';
}

function toggleFsDay(index) {
    const dayItem = document.querySelector('.fs-day-item[data-day="' + index + '"]');
    const dayContent = document.getElementById('fs-day-content-' + index);
    
    if (dayItem && dayContent) {
        if (dayItem.classList.contains('expanded')) {
            dayItem.classList.remove('expanded');
            dayContent.style.display = 'none';
        } else {
            dayItem.classList.add('expanded');
            dayContent.style.display = 'block';
        }
    }
}

let fsAllExpanded = false;
function toggleAllFsDays() {
    const btn = document.querySelector('.fs-expand-btn');
    const items = document.querySelectorAll('.fs-day-item');
    const contents = document.querySelectorAll('.fs-day-content');

    fsAllExpanded = !fsAllExpanded;

    items.forEach(item => {
        if (fsAllExpanded) {
            item.classList.add('expanded');
        } else {
            item.classList.remove('expanded');
        }
    });

    contents.forEach(content => {
        content.style.display = fsAllExpanded ? 'block' : 'none';
    });

    if (btn) {
        btn.textContent = fsAllExpanded ? 'collapse all' : 'expand all';
    }
}

