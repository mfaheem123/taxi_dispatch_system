# Dashboard Keyboard Navigation Guide

## Overview
The dashboard now supports comprehensive keyboard navigation, allowing users to navigate through all form elements and interactive components using the Tab key and Enter key.

## Navigation Keys

### Tab Navigation
- **Tab**: Move to the next focusable element
- **Shift + Tab**: Move to the previous focusable element

### Action Keys
- **Enter**: Activate the currently focused element (button, checkbox, switch, etc.)
- **Arrow Keys**: Navigate through dropdown menus and suggestions
- **Escape**: Close dropdowns and modals

## Focus Order

The Tab navigation follows this logical order through the booking form:

1. **Pickup Location Field** - Enter pickup address
2. **Dropoff Location Field** - Enter destination address
3. **Via Location 1 Field** - First intermediate stop (if Two Way journey)
4. **Via Location 2 Field** - Second intermediate stop (if Two Way journey)
5. **User Information Fields** - Name, email, mobile, telephone
6. **Date Field** - Journey date picker
7. **Time Field** - Journey time picker
8. **Lead Time Field** - Minutes in advance
9. **Journey Type Dropdown** - One Way, Return, etc.
10. **Driver Dropdown** - Select driver
11. **Fare Field** - Enter fare amount
12. **Account Field** - Select account
13. **Payment Method Dropdown** - Cash, Credit Card, etc.
14. **Vehicle Type Dropdown** - Saloon, Estate, MPV, etc.
15. **Quotation Switch** - Toggle quotation mode
16. **SMS Checkbox** - Enable/disable SMS notifications
17. **Email Checkbox** - Enable/disable email notifications
18. **Passengers Field** - Number of passengers
19. **Luggage Field** - Number of luggage items
20. **Special Luggage Field** - Special luggage count
21. **Clear Button** - Clear all form fields
22. **Save Button** - Save the booking

## Using the Navigation System

### Basic Navigation
1. **Start Navigation**: Press Tab to begin navigating through the form
2. **Move Forward**: Press Tab to move to the next field
3. **Move Backward**: Press Shift + Tab to move to the previous field
4. **Activate Elements**: Press Enter to interact with the focused element

### Form Field Interaction
- **Text Fields**: Tab to focus, type content, Tab to next field
- **Dropdowns**: Tab to focus, Enter to open, Arrow keys to navigate, Enter to select
- **Checkboxes**: Tab to focus, Enter to toggle
- **Switches**: Tab to focus, Enter to toggle
- **Buttons**: Tab to focus, Enter to click

### Advanced Features
- **Auto-suggestions**: Use arrow keys to navigate through location suggestions
- **Form Validation**: Focus remains on invalid fields until corrected
- **Keyboard Shortcuts**: F2, F3, F4, F7, Home keys for quick actions

## Accessibility Features

### Visual Indicators
- Focused elements show a clear visual highlight
- Current focus position is tracked and displayed
- Form state changes are visually indicated

### Screen Reader Support
- All interactive elements have proper labels
- Focus changes are announced
- Form validation messages are accessible

## Troubleshooting

### Common Issues
1. **Focus Not Moving**: Ensure no modal dialogs are open
2. **Elements Not Focusable**: Check if elements are disabled or hidden
3. **Navigation Skipping Elements**: Verify all elements have proper focus nodes

### Reset Navigation
- Press Escape to close any open dropdowns
- Use F7 to clear the form and reset focus
- Refresh the page if navigation becomes unresponsive

## Best Practices

### For Users
- Use Tab for systematic navigation through forms
- Use Enter to activate focused elements
- Use Shift + Tab to move backward when needed
- Familiarize yourself with keyboard shortcuts

### For Developers
- Maintain consistent focus order
- Ensure all interactive elements are focusable
- Test navigation with keyboard-only input
- Keep focus management logic centralized

## Technical Implementation

The keyboard navigation system is implemented using:
- **FocusNode**: Manages focus state for each widget
- **RawKeyboardListener**: Captures keyboard events
- **Focus Widgets**: Wraps interactive elements
- **Controller Logic**: Centralized focus management

### Adding New Focusable Elements
1. Add a new FocusNode to the controller
2. Include it in the `focusableWidgets` list
3. Wrap the widget with a Focus widget
4. Add Enter key handling if needed

This system provides a seamless, accessible user experience for both mouse and keyboard users.
