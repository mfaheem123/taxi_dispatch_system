# Keyboard Navigation Demo

## How to Test

### 1. **Start the Application**
- Run your Flutter app
- Navigate to the dashboard with the booking form

### 2. **Test Tab Navigation**
- **Press Tab** to move to the next field
- **Press Shift + Tab** to move to the previous field
- Watch the focus indicator at the top of the form

### 3. **What You Should See**
- **Blue focus bar** showing current position (e.g., "Focus: Field 1 of 8")
- **Orange focus field name** showing which field is currently focused
- **Visual focus changes** as you press Tab

### 4. **Navigation Order**
The Tab key will cycle through these fields:
1. Pickup Location
2. Dropoff Location  
3. Via Location 1 (if Two Way journey)
4. Via Location 2 (if Two Way journey)
5. Pickup Text Field
6. Dropoff Text Field
7. Via 1 Text Field
8. Via 2 Text Field

### 5. **Expected Behavior**
- **Tab**: Move to next field
- **Shift + Tab**: Move to previous field
- **Focus wraps around** at the end/beginning
- **Visual indicator updates** with each focus change

## Troubleshooting

### If Tab Navigation Doesn't Work:
1. **Check console** for any error messages
2. **Verify focus nodes** are properly initialized
3. **Ensure RawKeyboardListener** is wrapping the form
4. **Check controller** has focusableElements list populated

### If Focus Doesn't Move:
1. **Verify FocusNode** is properly attached to widgets
2. **Check onFocusChange** callbacks are working
3. **Ensure no other widgets** are capturing focus

## Code Structure

### Controller (`dashboard_controller.dart`)
```dart
// Focus management
final List<FocusNode> focusableElements = [];
int currentFocusIndex = 0;

void focusNext() { /* moves to next element */ }
void focusPrevious() { /* moves to previous element */ }
void handleTabNavigation(bool isShiftTab) { /* handles Tab key */ }
```

### Form Widget (`booking_form_widget.dart`)
```dart
RawKeyboardListener(
  onKey: (event) {
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      controller.handleTabNavigation(event.isShiftPressed);
    }
  },
  child: /* your form content */
)
```

### Focus Indicator
- **Blue bar**: Shows current focus position
- **Orange bar**: Shows currently focused field name
- **Real-time updates**: Changes as you navigate

## Testing Steps

1. **Basic Navigation**
   - Press Tab multiple times
   - Verify focus moves through fields
   - Check focus indicator updates

2. **Reverse Navigation**
   - Press Shift + Tab
   - Verify focus moves backward
   - Check focus indicator updates

3. **Wrap Around**
   - Press Tab until you reach the end
   - Press Tab again to verify it wraps to first field
   - Do the same with Shift + Tab

4. **Visual Feedback**
   - Verify focus indicator shows correct position
   - Check that focused field name updates
   - Ensure no visual glitches

## Success Criteria

✅ **Tab key moves focus forward**
✅ **Shift + Tab moves focus backward**  
✅ **Focus wraps around at boundaries**
✅ **Visual indicator updates correctly**
✅ **No console errors**
✅ **Smooth focus transitions**

If all these work, your keyboard navigation is functioning correctly!
