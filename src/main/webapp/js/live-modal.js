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
        border-radius: 20px 20px 0 0 !important;
        box-shadow: 0 -5px 20px rgba(0, 0, 0, 0.2) !important;
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
    
    console.log('Day data found:', dayData);
    
    // Set title
    modalTitle.textContent = `Day ${dayIndex + 1} - ${dayData.title || dayData.name || 'Daily Schedule'}`;
    
    // Clear content
    modalContent.innerHTML = '';
    
    // Create detailed modal content
    createDetailedModalContent(dayData, dayIndex, modalContent);
    
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
    
    // Find the day card for the given index
    const dayCards = document.querySelectorAll('.day-card');
    const dayCard = dayCards[dayIndex];
    
    if (!dayCard) {
        console.log('Day card not found for index:', dayIndex);
        return {
            title: `Day ${dayIndex + 1}`,
            date: new Date().toLocaleDateString('ko-KR'),
            distance: 'No data',
            duration: 'No data',
            activities: []
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

// Create detailed modal content with blue/white/gray sections
function createDetailedModalContent(dayData, dayIndex, modalContent) {
    // Get real data from the page
    const realDayData = getRealDayData(dayIndex);
    
    // Blue section - Day summary header
    const daySummaryHeader = document.createElement('div');
    daySummaryHeader.className = 'day-summary-header';
    
    const daySummaryTitle = document.createElement('h3');
    daySummaryTitle.className = 'day-summary-title';
    daySummaryTitle.textContent = `${dayIndex + 1}Day - ${realDayData.title || 'Daily Schedule'}`;
    
    const daySummaryInfo = document.createElement('div');
    daySummaryInfo.className = 'day-summary-info';
    
    // Use real data from page
    const dateItem = document.createElement('div');
    dateItem.className = 'day-summary-item';
    dateItem.textContent = realDayData.date || new Date().toLocaleDateString('ko-KR');
    
    const distanceItem = document.createElement('div');
    distanceItem.className = 'day-summary-item distance';
    distanceItem.textContent = realDayData.distance || 'Distance info not available';
    
    const durationItem = document.createElement('div');
    durationItem.className = 'day-summary-item duration';
    durationItem.textContent = realDayData.duration || 'Duration info not available';
    
    daySummaryInfo.appendChild(dateItem);
    daySummaryInfo.appendChild(distanceItem);
    daySummaryInfo.appendChild(durationItem);
    
    daySummaryHeader.appendChild(daySummaryTitle);
    daySummaryHeader.appendChild(daySummaryInfo);
    
    // White section - Activity details
    const activitySection = document.createElement('div');
    activitySection.className = 'activity-details-section';
    
    const activityHeader = document.createElement('div');
    activityHeader.className = 'activity-details-header';
    activityHeader.textContent = 'Detailed Schedule';
    
    const activityList = document.createElement('div');
    activityList.className = 'activity-details-list';
    
    // Use real activities from the page
    const realActivities = realDayData.activities;
    
    if (realActivities.length > 0) {
        realActivities.forEach((activity, index) => {
            const activityItem = document.createElement('div');
            activityItem.className = 'detailed-activity-item';
            
            const timeInfo = document.createElement('div');
            timeInfo.className = 'activity-time-info';
            timeInfo.textContent = activity.time || '';
            
            const contentInfo = document.createElement('div');
            contentInfo.className = 'activity-content-info';
            
            const titleElement = document.createElement('h4');
            titleElement.textContent = activity.name || '';
            
            const descElement = document.createElement('p');
            descElement.textContent = activity.description || '';
            
            contentInfo.appendChild(titleElement);
            contentInfo.appendChild(descElement);
            
            const costInfo = document.createElement('div');
            costInfo.className = 'activity-cost-info';
            costInfo.textContent = activity.cost || '';
            
            activityItem.appendChild(timeInfo);
            activityItem.appendChild(contentInfo);
            activityItem.appendChild(costInfo);
            
            activityList.appendChild(activityItem);
        });
    } else {
        const emptyItem = document.createElement('div');
        emptyItem.className = 'detailed-activity-item';
        emptyItem.innerHTML = '<div style="text-align: center; color: #999; padding: 20px;">No activities scheduled</div>';
        activityList.appendChild(emptyItem);
    }
    
    activitySection.appendChild(activityHeader);
    activitySection.appendChild(activityList);
    
    // Gray section - Cost summary
    const costSection = document.createElement('div');
    costSection.className = 'cost-summary-section';
    
    const costTitle = document.createElement('h3');
    costTitle.className = 'cost-summary-title';
    costTitle.textContent = 'Estimated Costs';
    
    // Calculate real costs from activities
    let totalCost = 0;
    let transportCost = 0;
    let foodCost = 0;
    let otherCost = 0;
    
    realActivities.forEach(activity => {
        const costText = activity.cost || '0';
        const costValue = parseInt(costText.replace(/[^\d]/g, '')) || 0;
        totalCost += costValue;
        
        // Categorize costs based on activity type
        if (activity.category === 'TRANSPORT' || activity.category === 'MOVE') {
            transportCost += costValue;
        } else if (activity.category === 'DINING' || activity.category === 'FOOD' || activity.category === 'RESTAURANT') {
            foodCost += costValue;
        } else {
            otherCost += costValue;
        }
    });
    
    // Create cost details with real data
    const costDetails = document.createElement('div');
    costDetails.className = 'cost-summary-details';
    
    const transportLabel = document.createElement('div');
    transportLabel.className = 'cost-label';
    transportLabel.textContent = 'Transportation';
    
    const transportValue = document.createElement('div');
    transportValue.className = 'cost-value';
    transportValue.textContent = transportCost > 0 ? `¥${transportCost.toLocaleString()}` : '¥0';
    
    const foodLabel = document.createElement('div');
    foodLabel.className = 'cost-label';
    foodLabel.textContent = 'Food & Dining';
    
    const foodValue = document.createElement('div');
    foodValue.className = 'cost-value';
    foodValue.textContent = foodCost > 0 ? `¥${foodCost.toLocaleString()}` : '¥0';
    
    const otherLabel = document.createElement('div');
    otherLabel.className = 'cost-label';
    otherLabel.textContent = 'Other Expenses';
    
    const otherValue = document.createElement('div');
    otherValue.className = 'cost-value';
    otherValue.textContent = otherCost > 0 ? `¥${otherCost.toLocaleString()}` : '¥0';
    
    // Total cost
    const totalLabel = document.createElement('div');
    totalLabel.className = 'cost-label';
    totalLabel.textContent = 'Total Estimated';
    
    const totalValue = document.createElement('div');
    totalValue.className = 'cost-value total';
    totalValue.textContent = totalCost > 0 ? `¥${totalCost.toLocaleString()}` : '¥0';
    
    costDetails.appendChild(transportLabel);
    costDetails.appendChild(transportValue);
    
    const foodDetails = document.createElement('div');
    foodDetails.className = 'cost-summary-details';
    foodDetails.appendChild(foodLabel);
    foodDetails.appendChild(foodValue);
    
    const otherDetails = document.createElement('div');
    otherDetails.className = 'cost-summary-details';
    otherDetails.appendChild(otherLabel);
    otherDetails.appendChild(otherValue);
    
    const totalDetails = document.createElement('div');
    totalDetails.className = 'cost-summary-details';
    totalDetails.appendChild(totalLabel);
    totalDetails.appendChild(totalValue);
    
    costSection.appendChild(costTitle);
    costSection.appendChild(costDetails);
    costSection.appendChild(foodDetails);
    costSection.appendChild(otherDetails);
    costSection.appendChild(totalDetails);
    
    // Append all sections to modal content
    modalContent.appendChild(daySummaryHeader);
    modalContent.appendChild(activitySection);
    modalContent.appendChild(costSection);
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
    
    // Try different selectors to find day headers
    let dayHeaders = document.querySelectorAll('.day-header');
    if (dayHeaders.length === 0) {
        dayHeaders = document.querySelectorAll('.day-toggle');
    }
    if (dayHeaders.length === 0) {
        dayHeaders = document.querySelectorAll('.itinerary-container .day-item');
    }
    if (dayHeaders.length === 0) {
        dayHeaders = document.querySelectorAll('[class*="day"]');
    }
    
    console.log('Found day headers:', dayHeaders.length);
    
    dayHeaders.forEach((header, index) => {
        // Check if button already exists
        if (header.querySelector('.day-click-btn')) return;
        
        console.log('Adding button to header:', header, 'index:', index);
        
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
        header.appendChild(clickBtn);
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
