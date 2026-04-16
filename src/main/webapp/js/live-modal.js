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

    // 선택된 activity의 날짜 가져오기 (dayIndex → PLAN_DETAIL.itinerary[dayIndex].date)
    let dayDate = null;
    if (window.PLAN_DETAIL && window.PLAN_DETAIL.itinerary && activity.dayIndex !== undefined) {
        const dayData = window.PLAN_DETAIL.itinerary[activity.dayIndex];
        if (dayData) dayDate = dayData.date || null;
    }

    // 현재 시간 기준 상태 계산 및 표시 (날짜 포함)
    applyActivityStatus(activity, dayDate);

    // 선택된 activity와 날짜를 전역에 저장 (1분마다 갱신용)
    window._liveSelectedActivity = activity;
    window._liveSelectedDayDate  = dayDate;

    // Update next schedule information
    updateNextScheduleInfo(activity);

    // Close modal after selection
    closeFullScheduleModal();
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

// ─── Full Schedule Bottom-Sheet Modal ───────────────────────────────────────
let fsModalOverlay = null;
let fsAllExpanded  = false;

/* 카테고리별 아이콘 매핑 */
function _fsCategoryIcon(cat) {
    const map = {
        TRANSPORT: '🚌', MOVE: '🚌', FLIGHT: '✈️',
        HOTEL: '🏨', ACCOMMODATION: '🏨',
        DINING: '🍽️', FOOD: '🍽️', RESTAURANT: '🍽️',
        SHOPPING: '🛍️', CULTURE: '🏛️', MUSEUM: '🏛️',
        NATURE: '🌿', ACTIVITY: '🎡', TOUR: '🗺️',
        CAFE: '☕', SPA: '♨️'
    };
    if (!cat) return '📍';
    const key = cat.toString().toUpperCase();
    for (const [k, v] of Object.entries(map)) {
        if (key.includes(k)) return v;
    }
    return '📍';
}

/* 비용 포맷 */
function _fsFmtCost(cost, currency) {
    if (!cost || cost === '0' || cost === 0) return '무료';
    const num = parseInt(String(cost).replace(/[^0-9]/g, ''), 10);
    if (!num) return '무료';
    const cur = currency || 'KRW';
    return num.toLocaleString() + ' ' + cur;
}

/* 소요시간 포맷 */
function _fsFmtDur(min) {
    const m = parseInt(min, 10);
    if (!m || isNaN(m)) return '';
    return m + '분';
}

function openFullScheduleModal() {
    const planDetail = window.PLAN_DETAIL;
    if (!planDetail || !planDetail.itinerary) {
        console.error('PLAN_DETAIL이 없습니다.');
        return;
    }

    // 이미 열려있으면 제거
    if (fsModalOverlay) { fsModalOverlay.remove(); fsModalOverlay = null; }
    fsAllExpanded = false;

    /* ── 배경 오버레이 ── */
    fsModalOverlay = document.createElement('div');
    fsModalOverlay.id = 'fs-modal-overlay';
    Object.assign(fsModalOverlay.style, {
        position:'fixed', top:'0', left:'0',
        width:'100%', height:'100%',
        background:'rgba(0,0,0,0.5)',
        zIndex:'99999',
        display:'flex', alignItems:'flex-end'
    });
    fsModalOverlay.addEventListener('click', e => {
        if (e.target === fsModalOverlay) closeFullScheduleModal();
    });

    /* ── 바텀시트 ── */
    const sheet = document.createElement('div');
    Object.assign(sheet.style, {
        width:'100%', maxHeight:'85vh',
        background:'#f8fafc',
        borderRadius:'20px 20px 0 0',
        display:'flex', flexDirection:'column',
        overflow:'hidden',
        boxShadow:'0 -6px 32px rgba(0,0,0,0.18)',
        transform:'translateY(100%)',
        transition:'transform 0.32s cubic-bezier(0.32,0.72,0,1)'
    });

    /* 드래그 핸들 */
    const handle = document.createElement('div');
    Object.assign(handle.style, {
        width:'40px', height:'4px', background:'#cbd5e1',
        borderRadius:'2px', margin:'10px auto 0', flexShrink:'0'
    });
    sheet.appendChild(handle);

    /* 상단 헤더 */
    const header = document.createElement('div');
    Object.assign(header.style, {
        display:'flex', alignItems:'center', justifyContent:'space-between',
        padding:'12px 18px 14px', background:'#fff',
        borderBottom:'1px solid #e2e8f0', flexShrink:'0'
    });
    header.innerHTML = `<h3 style="margin:0;font-size:16px;font-weight:700;color:#0f172a;">상세 일정</h3>`;

    const rightGrp = document.createElement('div');
    Object.assign(rightGrp.style, { display:'flex', alignItems:'center', gap:'8px' });

    const expandBtn = document.createElement('button');
    expandBtn.id = 'fs-expand-btn';
    expandBtn.textContent = '전체 펼치기';
    Object.assign(expandBtn.style, {
        background:'#3b82f6', color:'#fff', border:'none',
        borderRadius:'8px', padding:'5px 12px',
        fontSize:'12px', fontWeight:'600', cursor:'pointer'
    });
    expandBtn.onclick = toggleAllFsDays;

    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '✕';
    Object.assign(closeBtn.style, {
        background:'transparent', border:'none',
        fontSize:'18px', color:'#94a3b8', cursor:'pointer', padding:'0'
    });
    closeBtn.onclick = closeFullScheduleModal;

    rightGrp.appendChild(expandBtn);
    rightGrp.appendChild(closeBtn);
    header.appendChild(rightGrp);
    sheet.appendChild(header);

    /* 스크롤 영역 */
    const scrollArea = document.createElement('div');
    Object.assign(scrollArea.style, { overflowY:'auto', flex:'1', paddingBottom:'30px' });

    /* ── 일자별 아코디언 ── */
    planDetail.itinerary.forEach((dayData, index) => {
        const dayNum = dayData.day || (index + 1);

        // 예상비용 합산
        let totalCost = 0;
        const currency = (dayData.activities && dayData.activities[0] && dayData.activities[0].currency)
            || dayData.currency || 'KRW';
        (dayData.activities || []).forEach(a => {
            const v = parseInt(String(a.cost || '0').replace(/[^0-9]/g,''), 10);
            if (!isNaN(v)) totalCost += v;
        });

        /* 아코디언 아이템 컨테이너 */
        const dayItem = document.createElement('div');
        dayItem.className = 'fs-day-item';
        dayItem.dataset.day = index;
        Object.assign(dayItem.style, { background:'#f8fafc' });

        /* ── 헤더 토글 버튼 (D2 2일차 …) ── */
        const dayToggle = document.createElement('div');
        dayToggle.className = 'fs-day-toggle';
        Object.assign(dayToggle.style, {
            display:'flex', alignItems:'flex-start', gap:'12px',
            padding:'14px 16px', cursor:'pointer',
            background:'#fff', borderBottom:'1px solid #e2e8f0',
            transition:'background 0.15s'
        });
        dayToggle.onmouseenter = () => dayToggle.style.background = '#f0f9ff';
        dayToggle.onmouseleave = () => dayToggle.style.background = '#fff';
        dayToggle.onclick = () => toggleFsDay(index);

        // D2 뱃지
        const badge = document.createElement('div');
        Object.assign(badge.style, {
            background:'#3b82f6', color:'#fff',
            width:'38px', height:'38px', borderRadius:'10px',
            display:'flex', flexDirection:'column',
            alignItems:'center', justifyContent:'center',
            fontSize:'9px', fontWeight:'800', lineHeight:'1.2',
            flexShrink:'0', letterSpacing:'0.5px'
        });
        badge.innerHTML = `<span style="font-size:8px;opacity:0.85;">D${dayNum}</span><span style="font-size:13px;">${dayNum}일차</span>`;

        // 날짜 + 이동정보 텍스트
        const dayInfoWrap = document.createElement('div');
        Object.assign(dayInfoWrap.style, { flex:'1', minWidth:'0' });
        dayInfoWrap.innerHTML = `
            <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
                <span style="font-size:14px;font-weight:700;color:#0f172a;">${dayNum}일차</span>
                <span style="font-size:11px;color:#64748b;">${dayData.date || ''}</span>
            </div>
            <div style="font-size:11px;color:#94a3b8;margin-top:2px;">
                ${dayData.summary || ''}
            </div>
        `;

        const toggleIcon = document.createElement('span');
        toggleIcon.className = 'fs-toggle-icon';
        Object.assign(toggleIcon.style, {
            color:'#94a3b8', fontSize:'18px',
            transition:'transform 0.2s', marginTop:'8px', flexShrink:'0'
        });
        toggleIcon.innerHTML = '&#8250;';

        dayToggle.appendChild(badge);
        dayToggle.appendChild(dayInfoWrap);
        dayToggle.appendChild(toggleIcon);

        /* ── 콘텐츠 패널 ── */
        const dayContent = document.createElement('div');
        dayContent.className = 'fs-day-content';
        dayContent.id = 'fs-day-content-' + index;
        dayContent.style.display = 'none';

        const activities = dayData.activities || [];
        if (activities.length > 0) {
            activities.forEach((act, ai) => {
                const isLast = (ai === activities.length - 1);
                const icon = _fsCategoryIcon(act.category);
                const costStr = _fsFmtCost(act.cost, act.currency || currency);
                const durStr  = _fsFmtDur(act.durationMinutes);
                const isFree  = costStr === '무료';

                const actRow = document.createElement('div');
                Object.assign(actRow.style, {
                    display:'flex', gap:'12px', alignItems:'flex-start',
                    padding:'12px 16px',
                    borderBottom: isLast ? 'none' : '1px solid #f1f5f9',
                    background:'#fff', cursor:'pointer',
                    transition:'background 0.15s'
                });
                actRow.onmouseenter = () => actRow.style.background = '#f0f9ff';
                actRow.onmouseleave = () => actRow.style.background = '#fff';
                actRow.onclick = () => showLocationRealtimeData({ ...act, dayIndex: index });

                // 시간
                const timeCol = document.createElement('div');
                Object.assign(timeCol.style, {
                    width:'42px', flexShrink:'0', paddingTop:'2px',
                    textAlign:'right'
                });
                timeCol.innerHTML = `<span style="font-size:12px;font-weight:600;color:#475569;">${act.time || ''}</span>`;

                // 수직 타임라인 선 + 아이콘
                const timelineCol = document.createElement('div');
                Object.assign(timelineCol.style, {
                    display:'flex', flexDirection:'column', alignItems:'center',
                    flexShrink:'0', width:'28px'
                });
                timelineCol.innerHTML = `
                    <div style="width:28px;height:28px;border-radius:50%;background:#eff6ff;
                                border:2px solid #bfdbfe;display:flex;
                                align-items:center;justify-content:center;
                                font-size:14px;flex-shrink:0;">${icon}</div>
                    ${!isLast ? `<div style="width:2px;flex:1;min-height:12px;background:#e2e8f0;margin-top:4px;"></div>` : ''}
                `;

                // 내용
                const contentCol = document.createElement('div');
                Object.assign(contentCol.style, { flex:'1', minWidth:'0', paddingBottom:'4px' });

                // 이름 + 비용
                const nameLine = document.createElement('div');
                Object.assign(nameLine.style, {
                    display:'flex', justifyContent:'space-between',
                    alignItems:'flex-start', gap:'8px', flexWrap:'wrap'
                });
                nameLine.innerHTML = `
                    <span style="font-size:14px;font-weight:600;color:#0f172a;line-height:1.3;flex:1;">${act.name || ''}</span>
                    <span style="font-size:13px;font-weight:700;color:${isFree ? '#10b981' : '#ef4444'};flex-shrink:0;">${costStr}</span>
                `;

                // 설명 + 소요시간
                const metaLine = document.createElement('div');
                Object.assign(metaLine.style, { marginTop:'3px' });
                metaLine.innerHTML = `
                    <div style="font-size:11px;color:#64748b;line-height:1.4;">${act.description || ''}</div>
                    ${durStr ? `<div style="font-size:11px;color:#94a3b8;margin-top:2px;">⏱ ${durStr}</div>` : ''}
                `;

                contentCol.appendChild(nameLine);
                contentCol.appendChild(metaLine);

                actRow.appendChild(timeCol);
                actRow.appendChild(timelineCol);
                actRow.appendChild(contentCol);
                dayContent.appendChild(actRow);
            });

            // ── 예상 비용 합계 푸터 ──
            const footer = document.createElement('div');
            Object.assign(footer.style, {
                display:'flex', justifyContent:'space-between', alignItems:'center',
                padding:'10px 16px',
                background:'#eff6ff', borderTop:'1px solid #dbeafe'
            });
            footer.innerHTML = `
                <span style="font-size:12px;color:#3b82f6;font-weight:600;">${dayNum}일차 예상 일정</span>
                <span style="font-size:13px;font-weight:700;color:#1d4ed8;">
                    예상 비용: ${totalCost > 0 ? totalCost.toLocaleString() + ' ' + currency : '무료'}
                </span>
            `;
            dayContent.appendChild(footer);

        } else {
            const empty = document.createElement('div');
            Object.assign(empty.style, {
                padding:'24px', textAlign:'center',
                color:'#94a3b8', fontSize:'13px', background:'#fff'
            });
            empty.textContent = '아직 등록된 일정이 없습니다.';
            dayContent.appendChild(empty);
        }

        dayItem.appendChild(dayToggle);
        dayItem.appendChild(dayContent);
        scrollArea.appendChild(dayItem);
    });

    sheet.appendChild(scrollArea);
    fsModalOverlay.appendChild(sheet);
    document.body.appendChild(fsModalOverlay);
    document.body.style.overflow = 'hidden';

    // 슬라이드업 애니메이션
    requestAnimationFrame(() => requestAnimationFrame(() => {
        sheet.style.transform = 'translateY(0)';
    }));
}

function closeFullScheduleModal() {
    if (!fsModalOverlay) return;
    const sheet = fsModalOverlay.firstElementChild;
    if (sheet) {
        sheet.style.transform = 'translateY(100%)';
        setTimeout(() => {
            if (fsModalOverlay) { fsModalOverlay.remove(); fsModalOverlay = null; }
            document.body.style.overflow = '';
        }, 320);
    } else {
        fsModalOverlay.remove(); fsModalOverlay = null;
        document.body.style.overflow = '';
    }
}

function toggleFsDay(index) {
    const dayItem    = document.querySelector('.fs-day-item[data-day="' + index + '"]');
    const dayContent = document.getElementById('fs-day-content-' + index);
    const icon       = dayItem && dayItem.querySelector('.fs-toggle-icon');
    if (!dayItem || !dayContent) return;

    if (dayItem.classList.contains('expanded')) {
        dayItem.classList.remove('expanded');
        dayContent.style.display = 'none';
        if (icon) icon.style.transform = 'rotate(0deg)';
    } else {
        dayItem.classList.add('expanded');
        dayContent.style.display = 'block';
        if (icon) icon.style.transform = 'rotate(90deg)';
    }
}

function toggleAllFsDays() {
    const btn   = document.getElementById('fs-expand-btn');
    const items = document.querySelectorAll('.fs-day-item');
    fsAllExpanded = !fsAllExpanded;

    items.forEach(item => {
        const idx     = item.dataset.day;
        const content = document.getElementById('fs-day-content-' + idx);
        const icon    = item.querySelector('.fs-toggle-icon');
        if (fsAllExpanded) {
            item.classList.add('expanded');
            if (content) content.style.display = 'block';
            if (icon)    icon.style.transform   = 'rotate(90deg)';
        } else {
            item.classList.remove('expanded');
            if (content) content.style.display = 'none';
            if (icon)    icon.style.transform   = 'rotate(0deg)';
        }
    });
    if (btn) btn.textContent = fsAllExpanded ? '전체 접기' : '전체 펼치기';
}

// ─── 현재 시간 기준 활동 상태 계산 ────────────────────────────────────────────

/**
 * activity.time ('HH:mm') + activity.durationMinutes + dayDate('YYYY-MM-DD') 를 이용해
 * { status: '진행 중'|'지난 일정'|'다음 일정', remainingMin: number|null } 반환
 * dayDate 가 있으면 날짜도 함께 비교하고, 없으면 기존처럼 시간만 비교한다.
 */
function calcActivityStatus(activity, dayDate) {
    const time = activity.time || '';
    const parts = time.split(':');
    if (parts.length < 2) return { status: '다음 일정', remainingMin: null };

    const now = new Date();

    // ── 날짜 비교 (dayDate 가 'YYYY-MM-DD' 형식으로 제공된 경우) ──
    if (dayDate) {
        const actDateStr = String(dayDate).substring(0, 10); // 'YYYY-MM-DD'
        const todayStr   = now.getFullYear() + '-' +
            String(now.getMonth() + 1).padStart(2, '0') + '-' +
            String(now.getDate()).padStart(2, '0');

        if (actDateStr && actDateStr !== '${item.date}') { // JSP 미렌더링 방어
            if (todayStr < actDateStr) {
                return { status: '다음 일정', remainingMin: null };
            } else if (todayStr > actDateStr) {
                return { status: '지난 일정', remainingMin: null };
            }
            // todayStr === actDateStr → 아래 시간 비교로 진행
        }
    }

    // ── 시간 비교 ──
    const startMin = parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10);
    const dur      = parseInt(activity.durationMinutes || 0, 10);
    const endMin   = startMin + (dur > 0 ? dur : 60); // 소요시간 없으면 1시간 기본
    const nowMin   = now.getHours() * 60 + now.getMinutes();

    if (nowMin >= startMin && nowMin < endMin) {
        return { status: '진행 중', remainingMin: endMin - nowMin };
    } else if (nowMin >= endMin) {
        return { status: '지난 일정', remainingMin: null };
    } else {
        return { status: '다음 일정', remainingMin: null };
    }
}

/**
 * 상태 계산 결과를 DOM 요소에 반영
 * - #liveActivityStatus : 진행 중 / 지난 일정 / 다음 일정
 * - #liveRemainingMin   : 남은 시간(분) — 진행 중일 때만 표시
 * - .status-badge       : 상태에 따라 색상 클래스 교체
 * @param {object} activity
 * @param {string} [dayDate] - 'YYYY-MM-DD' 형식의 일정 날짜 (날짜 비교에 사용)
 */
function applyActivityStatus(activity, dayDate) {
    if (!activity) return;
    const { status, remainingMin } = calcActivityStatus(activity, dayDate);

    // 상태 텍스트
    const stEl = document.getElementById('liveActivityStatus');
    if (stEl) stEl.textContent = status;

    // 상태 배지 색상
    const badge = stEl && stEl.closest('.status-badge');
    if (badge) {
        badge.classList.remove('status-active', 'status-past', 'status-future');
        if (status === '진행 중')      badge.classList.add('status-active');
        else if (status === '지난 일정') badge.classList.add('status-past');
        else                           badge.classList.add('status-future');
    }

    // 남은 시간
    const rmEl = document.getElementById('liveRemainingMin');
    const rmWrap = rmEl && rmEl.closest('.time-remaining');
    if (rmEl) {
        if (status === '진행 중' && remainingMin != null) {
            rmEl.textContent = String(remainingMin);
            if (rmWrap) rmWrap.style.display = '';
        } else {
            rmEl.textContent = '-';
            if (rmWrap) rmWrap.style.display = 'none';
        }
    }
}

/**
 * PLAN_DETAIL 전체를 스캔해 오늘 날짜 + 현재 시간에 맞는 활동을 자동 감지하고
 * 대시보드를 업데이트한다. (1분마다 반복)
 * 날짜 정보가 없는 경우 기존처럼 시간만 비교한다.
 */
function autoDetectCurrentActivity() {
    const planDetail = window.PLAN_DETAIL;
    if (!planDetail || !planDetail.itinerary) return;

    const now = new Date();
    const todayStr = now.getFullYear() + '-' +
        String(now.getMonth() + 1).padStart(2, '0') + '-' +
        String(now.getDate()).padStart(2, '0');
    const nowMin   = now.getHours() * 60 + now.getMinutes();

    let found        = null;
    let foundDayDate = null;

    outer:
        for (const day of planDetail.itinerary) {
            const dayDateStr = (day.date || '').substring(0, 10);

            // 날짜 정보가 있으면 오늘 날짜 day만 스캔 (다른 날은 건너뜀)
            if (dayDateStr && dayDateStr !== '${item.date}') {
                if (dayDateStr !== todayStr) continue;
            }

            for (const act of (day.activities || [])) {
                const parts = (act.time || '').split(':');
                if (parts.length < 2) continue;
                const startMin = parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10);
                const dur      = parseInt(act.durationMinutes || 0, 10);
                const endMin   = startMin + (dur > 0 ? dur : 60);

                // 진행 중인 활동 우선
                if (nowMin >= startMin && nowMin < endMin) {
                    found        = act;
                    foundDayDate = day.date || null;
                    break outer;
                }
            }
        }

    // 진행중인 게 없으면 _liveSelectedActivity 유지
    if (found) {
        const titleEl = document.getElementById('liveActivityTitle');
        if (titleEl) titleEl.textContent = found.name || '';
        const startEl = document.getElementById('liveActivityStart');
        if (startEl) startEl.textContent = found.time || '-';
        window._liveSelectedActivity = found;
        window._liveSelectedDayDate  = foundDayDate;
    }

    // 선택된(또는 자동감지된) 활동의 상태를 최신 시간 + 날짜로 재계산
    if (window._liveSelectedActivity) {
        applyActivityStatus(window._liveSelectedActivity, window._liveSelectedDayDate);
    }
}

// 페이지 로드 시 1회 실행, 이후 매 1분 갱신
document.addEventListener('DOMContentLoaded', function () {
    autoDetectCurrentActivity();
    setInterval(autoDetectCurrentActivity, 60000);
});
