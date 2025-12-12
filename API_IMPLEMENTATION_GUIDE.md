# API Implementation Guide - Mom App

## 📋 Overview

This guide provides a structured approach to implementing APIs across the Mom App. The app is organized into several feature modules, each requiring specific API endpoints.

**Base URL:** `https://busy-pandas-dream.loca.lt`

**Current Status:**
- ✅ Authentication (Login/Signup) - **COMPLETED**
- ⏳ All other features - **PENDING**

---

## 🏗️ Architecture Pattern

### Current Structure:
```
lib/
├── services/
│   ├── api_service.dart          # Base HTTP service (GET, POST)
│   ├── auth_service.dart         # ✅ Authentication APIs
│   └── storage_service.dart      # Local storage management
├── models/
│   ├── auth_response_model.dart  # ✅ Auth response models
│   ├── parent_model.dart         # ✅ User/Parent model
│   ├── task_model.dart           # Task model
│   ├── calendar_event.dart       # Calendar event model
│   └── user_model.dart           # User model
└── viewmodels/
    └── auth_view_mode.dart       # ✅ Auth view model
```

### Implementation Pattern (Follow for all features):

1. **Create Service** (`lib/services/[feature]_service.dart`)
   - Use `ApiService.post()` or `ApiService.get()`
   - Add authentication token to headers
   - Handle errors and parse responses

2. **Create/Update Models** (`lib/models/[feature]_model.dart`)
   - Define data models with `fromJson()` and `toJson()`

3. **Create ViewModel** (`lib/viewmodels/[feature]_view_model.dart`)
   - Use GetX for state management
   - Call service methods
   - Handle loading states and errors

4. **Update UI** (`lib/views/[feature]/[feature]_screen.dart`)
   - Connect ViewModel to UI
   - Show loading states
   - Display data from API

---

## 🔐 Authentication Helper

**Important:** All authenticated API calls should include the token in headers:

```dart
// In your service file
final token = await StorageService.getToken();
final headers = {
  'Authorization': 'Bearer $token',
};
```

**Update ApiService** to automatically add token:
```dart
static Future<http.Response> get({
  required String endpoint,
  Map<String, String>? headers,
}) async {
  final token = await StorageService.getToken();
  final defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
  // ... rest of the code
}
```

---

## 📝 API Implementation Priority

### **Phase 1: Core Features (Start Here)**

#### 1. **Tasks API** ⭐ HIGH PRIORITY
**Location:** `lib/views/task/tasks_screen.dart`
**Current State:** Using sample data (`TaskModel.getSampleTasks()`)

**Required Endpoints:**
- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task
- `PATCH /api/tasks/:id/complete` - Toggle completion status

**Files to Create/Update:**
- `lib/services/task_service.dart` (NEW)
- `lib/models/task_model.dart` (UPDATE - add fromJson/toJson)
- `lib/viewmodels/task_view_model.dart` (NEW)
- `lib/views/task/tasks_screen.dart` (UPDATE - connect to ViewModel)

**Implementation Steps:**
1. Add `fromJson()` and `toJson()` to `TaskModel`
2. Create `TaskService` with CRUD methods
3. Create `TaskViewModel` with observable task list
4. Update `TaskScreen` to use ViewModel instead of sample data
5. Connect create/edit/delete modals to API calls

---

#### 2. **Calendar Events API** ⭐ HIGH PRIORITY
**Location:** `lib/views/calendar/calendar_screen.dart`
**Current State:** Using sample data (`CalendarEvent.getSampleEvents()`)

**Required Endpoints:**
- `GET /api/calendar/events` - Get all events (with date filters)
- `POST /api/calendar/events` - Create new event
- `PUT /api/calendar/events/:id` - Update event
- `DELETE /api/calendar/events/:id` - Delete event

**Files to Create/Update:**
- `lib/services/calendar_service.dart` (NEW)
- `lib/models/calendar_event.dart` (UPDATE - add fromJson/toJson)
- `lib/viewmodels/calendar_view_model.dart` (NEW)
- `lib/views/calendar/calendar_screen.dart` (UPDATE)
- `lib/views/calendar/create_event_modal.dart` (UPDATE)

**Implementation Steps:**
1. Update `CalendarEvent` model with JSON serialization
2. Create `CalendarService` with event CRUD operations
3. Create `CalendarViewModel` to manage events state
4. Update calendar screen to fetch events on load
5. Connect create event modal to API

---

#### 3. **Notes API** ⭐ MEDIUM PRIORITY
**Location:** `lib/views/notes/notes_screen.dart`
**Current State:** Using local state (`List<Map<String, String>> notes`)

**Required Endpoints:**
- `GET /api/notes` - Get all notes
- `POST /api/notes` - Create new note
- `PUT /api/notes/:id` - Update note
- `DELETE /api/notes/:id` - Delete note
- `GET /api/notes/voice` - Get voice notes
- `POST /api/notes/voice` - Upload voice note

**Files to Create/Update:**
- `lib/services/note_service.dart` (NEW)
- `lib/models/note_model.dart` (NEW)
- `lib/viewmodels/note_view_model.dart` (NEW)
- `lib/views/notes/notes_screen.dart` (UPDATE)

---

#### 4. **Meals & Grocery List API** ⭐ MEDIUM PRIORITY
**Location:** `lib/views/meals/meals_screen.dart`, `lib/views/meals/grocery_list_screen.dart`
**Current State:** Using local state

**Required Endpoints:**
- `GET /api/meals/plans` - Get meal plans
- `POST /api/meals/plans` - Create meal plan
- `PUT /api/meals/plans/:id` - Update meal plan
- `DELETE /api/meals/plans/:id` - Delete meal plan
- `GET /api/grocery/list` - Get grocery list
- `POST /api/grocery/items` - Add grocery item
- `PUT /api/grocery/items/:id` - Update item (toggle completed)
- `DELETE /api/grocery/items/:id` - Delete item

**Files to Create/Update:**
- `lib/services/meal_service.dart` (NEW)
- `lib/models/meal_model.dart` (NEW)
- `lib/models/grocery_item_model.dart` (NEW)
- `lib/viewmodels/meal_view_model.dart` (NEW)
- `lib/views/meals/meals_screen.dart` (UPDATE)
- `lib/views/meals/grocery_list_screen.dart` (UPDATE)

---

### **Phase 2: Family & Settings**

#### 5. **Family Management API** ⭐ MEDIUM PRIORITY
**Location:** `lib/views/settings/settings_screen.dart`
**Current State:** Hardcoded family members

**Required Endpoints:**
- `GET /api/family/members` - Get all family members
- `POST /api/family/members` - Add family member (child/teen profile)
- `PUT /api/family/members/:id` - Update member details
- `DELETE /api/family/members/:id` - Remove member
- `POST /api/family/invite/parent` - Invite parent via email
- `POST /api/family/invite/teen` - Invite teen with username
- `POST /api/family/merge` - Merge families
- `GET /api/family/permissions/:memberId` - Get member permissions
- `PUT /api/family/permissions/:memberId` - Update permissions

**Files to Create/Update:**
- `lib/services/family_service.dart` (NEW)
- `lib/models/family_member_model.dart` (NEW)
- `lib/viewmodels/family_view_model.dart` (NEW)
- `lib/views/settings/settings_screen.dart` (UPDATE)

---

#### 6. **User Profile API** ⭐ LOW PRIORITY
**Location:** `lib/views/settings/profile_settings_modal.dart`

**Required Endpoints:**
- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update profile
- `PUT /api/user/password` - Change password
- `DELETE /api/user/account` - Delete account

**Files to Create/Update:**
- `lib/services/user_service.dart` (NEW)
- `lib/viewmodels/user_view_model.dart` (NEW)

---

#### 7. **Settings API** ⭐ LOW PRIORITY
**Location:** `lib/views/settings/settings_screen.dart`

**Required Endpoints:**
- `GET /api/settings` - Get user settings
- `PUT /api/settings` - Update settings (notifications, privacy, etc.)

---

### **Phase 3: Additional Features**

#### 8. **Home Dashboard API** ⭐ MEDIUM PRIORITY
**Location:** `lib/views/home/home_screen.dart`
**Current State:** Shows hardcoded stats

**Required Endpoints:**
- `GET /api/dashboard/stats` - Get dashboard statistics
- `GET /api/dashboard/tasks/today` - Get today's tasks
- `GET /api/dashboard/upcoming` - Get upcoming events

---

#### 9. **Family Chat API** ⭐ LOW PRIORITY
**Location:** `lib/views/home/home_screen.dart` (Family Chat tab)

**Required Endpoints:**
- `GET /api/chat/messages` - Get chat messages
- `POST /api/chat/messages` - Send message
- `GET /api/chat/recent` - Get recent conversations

---

#### 10. **Password Vault API** ⭐ LOW PRIORITY
**Location:** `lib/views/home/home_screen.dart` (Passwords tab)

**Required Endpoints:**
- `GET /api/passwords` - Get saved passwords
- `POST /api/passwords` - Save new password
- `PUT /api/passwords/:id` - Update password
- `DELETE /api/passwords/:id` - Delete password

---

## 🛠️ Implementation Template

### Service Template:
```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/[feature]_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class [Feature]Service {
  /// Get all items
  Future<List<[Feature]Model>> getAll() async {
    try {
      final token = await StorageService.getToken();
      final headers = {
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final response = await ApiService.get(
        endpoint: '/api/[feature]',
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body)['data'];
        return jsonList.map((json) => [Feature]Model.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load [feature]');
      }
    } catch (e) {
      debugPrint("❌ Error getting [feature]: $e");
      rethrow;
    }
  }

  /// Create new item
  Future<[Feature]Model> create([Feature]Model item) async {
    try {
      final token = await StorageService.getToken();
      final headers = {
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final response = await ApiService.post(
        endpoint: '/api/[feature]',
        body: item.toJson(),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body)['data'];
        return [Feature]Model.fromJson(json);
      } else {
        throw Exception('Failed to create [feature]');
      }
    } catch (e) {
      debugPrint("❌ Error creating [feature]: $e");
      rethrow;
    }
  }

  // Add update, delete methods similarly...
}
```

### ViewModel Template:
```dart
import 'package:get/get.dart';
import '../models/[feature]_model.dart';
import '../services/[feature]_service.dart';

class [Feature]ViewModel extends GetxController {
  final [Feature]Service _service = [Feature]Service();
  
  var items = <[Feature]Model>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    error.value = null;
    try {
      items.value = await _service.getAll();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar("Error", "Failed to load items");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createItem([Feature]Model item) async {
    isLoading.value = true;
    try {
      final newItem = await _service.create(item);
      items.add(newItem);
      Get.snackbar("Success", "Item created successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to create item");
    } finally {
      isLoading.value = false;
    }
  }

  // Add update, delete methods...
}
```

---

## 📋 Checklist for Each API Implementation

- [ ] Create/Update model with `fromJson()` and `toJson()`
- [ ] Create service file with all CRUD methods
- [ ] Add authentication headers to service methods
- [ ] Create ViewModel with observable state
- [ ] Update UI to use ViewModel
- [ ] Add loading states
- [ ] Add error handling
- [ ] Test API integration
- [ ] Add logging for debugging

---

## 🔄 Recommended Implementation Order

1. **Tasks API** (Most used feature)
2. **Calendar Events API** (High visibility)
3. **Notes API** (Simple CRUD)
4. **Meals & Grocery API** (Family coordination)
5. **Family Management API** (Core functionality)
6. **Dashboard API** (Aggregated data)
7. **User Profile API** (Settings)
8. **Chat API** (Optional feature)
9. **Password Vault API** (Optional feature)

---

## 💡 Tips

1. **Start Small:** Implement one endpoint at a time (e.g., GET first, then POST)
2. **Test Incrementally:** Test each endpoint before moving to the next
3. **Use Logging:** Keep the debug logging we added for troubleshooting
4. **Error Handling:** Always wrap API calls in try-catch
5. **Loading States:** Show loading indicators during API calls
6. **Offline Handling:** Consider caching data for offline access later

---

## 🐛 Common Issues & Solutions

1. **401 Unauthorized:** Token expired or missing
   - Solution: Check token in headers, implement token refresh if needed

2. **Network Errors:** Connection issues
   - Solution: Show user-friendly error messages, retry logic

3. **JSON Parsing Errors:** Response format mismatch
   - Solution: Check API response format, update model accordingly

4. **State Not Updating:** UI not reflecting API changes
   - Solution: Ensure using `.obs` for reactive variables, call `update()` or use GetX properly

---

## 📞 Next Steps

1. Review this guide
2. Choose the first API to implement (recommended: Tasks)
3. Follow the template and checklist
4. Test thoroughly
5. Move to the next API

**Good luck with your API implementation! 🚀**

