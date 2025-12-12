# Family Chat Section - API Requirements

Based on the Family Chat UI implementation, here are all the APIs required to complete the functionality:

## Current Features in Family Chat Section:

1. **Send Message Popup** - Send messages to family members
2. **Recent Chats** - Display recent messages/conversations
3. **Family Members** - Display list of family members (already implemented via `/api/children/family-members`)
4. **Quick Stats** - Show message statistics (Messages Today, Unread Messages, etc.)

---

## Required APIs:

### 1. ✅ Send Message (Already Provided)
**Endpoint:** `POST {{base_url}}/api/messages/send`

**Request Body:**
```json
{
  "recipientId": "6924c2462b6cb7aca8e4df68",
  "recipientType": "Child",  // Parent, Teen, Child
  "subject": "Don't forget",
  "message": "Pick up groceries on the way home!",
  "deliveryMethod": "in-app"  // sms, email, all
}
```

**Response:**
```json
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "message": {
      "sender": "6924b2f42de4d09e30e30966",
      "senderModel": "Parent",
      "senderName": "Shahir Islam",
      "recipient": "6924c2462b6cb7aca8e4df68",
      "recipientModel": "Child",
      "recipientName": "Musfika Haque",
      "subject": "Don't forget",
      "message": "Pick up groceries on the way home!",
      "deliveryMethod": "in-app",
      "deliveryStatus": {
        "inApp": {
          "sent": true,
          "read": false,
          "sentAt": "2025-11-26T22:57:24.026Z"
        },
        "sms": {
          "sent": false
        },
        "email": {
          "sent": false
        }
      },
      "isRead": false,
      "familyName": "Mushu's Family",
      "isDeleted": false,
      "_id": "692785d4250fb9d77b7e1aa1",
      "createdAt": "2025-11-26T22:57:24.029Z",
      "updatedAt": "2025-11-26T22:57:24.029Z",
      "__v": 0
    },
    "deliveryStatus": {
      "inApp": true,
      "sms": false,
      "email": false,
      "errors": {}
    }
  }
}
```

---

### 2. ❓ Get Messages / Recent Chats
**Endpoint:** `GET {{base_url}}/api/messages`

**Query Parameters (Optional):**
- `limit`: Number of messages to return (default: 20)
- `skip`: Number of messages to skip (for pagination)
- `sortBy`: Sort field (e.g., "createdAt")
- `sortOrder`: "asc" or "desc" (default: "desc")
- `isRead`: Filter by read status (true/false)
- `recipientId`: Filter by recipient
- `senderId`: Filter by sender

**Response:**
```json
{
  "success": true,
  "count": 10,
  "data": [
    {
      "_id": "692785d4250fb9d77b7e1aa1",
      "sender": "6924b2f42de4d09e30e30966",
      "senderModel": "Parent",
      "senderName": "Shahir Islam",
      "recipient": "6924c2462b6cb7aca8e4df68",
      "recipientModel": "Child",
      "recipientName": "Musfika Haque",
      "subject": "Don't forget",
      "message": "Pick up groceries on the way home!",
      "deliveryMethod": "in-app",
      "deliveryStatus": {
        "inApp": {
          "sent": true,
          "read": false,
          "sentAt": "2025-11-26T22:57:24.026Z"
        }
      },
      "isRead": false,
      "familyName": "Mushu's Family",
      "isDeleted": false,
      "createdAt": "2025-11-26T22:57:24.029Z",
      "updatedAt": "2025-11-26T22:57:24.029Z"
    }
  ]
}
```

**Purpose:** Display recent messages in the "Recent Chats" section

---

### 3. ❓ Mark Message as Read
**Endpoint:** `PATCH {{base_url}}/api/messages/{messageId}/read`

**Request Body:**
```json
{
  "isRead": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Message marked as read",
  "data": {
    "_id": "692785d4250fb9d77b7e1aa1",
    "isRead": true,
    "updatedAt": "2025-11-26T23:00:00.000Z"
  }
}
```

**Purpose:** Update message read status when user views a message

---

### 4. ❓ Get Message Statistics
**Endpoint:** `GET {{base_url}}/api/messages/stats`

**Query Parameters (Optional):**
- `date`: Filter by specific date (YYYY-MM-DD format)
- `startDate`: Start date for range
- `endDate`: End date for range

**Response:**
```json
{
  "success": true,
  "data": {
    "messagesToday": 5,
    "unreadMessages": 3,
    "totalMessages": 42,
    "messagesThisWeek": 12,
    "messagesThisMonth": 28
  }
}
```

**Purpose:** Display statistics in the "Quick Stats" section (Messages Today, Unread Messages, etc.)

---

### 5. ❓ Delete Message
**Endpoint:** `DELETE {{base_url}}/api/messages/{messageId}`

**Response:**
```json
{
  "success": true,
  "message": "Message deleted successfully"
}
```

**Purpose:** Allow users to delete messages (optional feature)

---

### 6. ✅ Get Family Members (Already Implemented)
**Endpoint:** `GET {{base_url}}/api/children/family-members`

**Status:** ✅ Already implemented in `FamilyViewModel` and `FamilyService`

**Purpose:** Display family members list in the "Family Members" section

---

## Summary:

### Required APIs (Total: 5-6 APIs)

1. ✅ **POST `/api/messages/send`** - Send message (Already provided)
2. ❓ **GET `/api/messages`** - Get messages/recent chats (Required)
3. ❓ **PATCH `/api/messages/{messageId}/read`** - Mark as read (Required)
4. ❓ **GET `/api/messages/stats`** - Get message statistics (Required)
5. ❓ **DELETE `/api/messages/{messageId}`** - Delete message (Optional)
6. ✅ **GET `/api/children/family-members`** - Get family members (Already implemented)

---

## Implementation Priority:

### High Priority (Must Have):
1. **GET `/api/messages`** - Essential for displaying recent chats
2. **PATCH `/api/messages/{messageId}/read`** - Important for read/unread status
3. **GET `/api/messages/stats`** - Needed for Quick Stats section

### Medium Priority (Nice to Have):
4. **DELETE `/api/messages/{messageId}`** - Useful for message management

### Already Implemented:
5. **POST `/api/messages/send`** - Ready to implement
6. **GET `/api/children/family-members`** - Already working

---

## Notes:

- The delivery method mapping:
  - UI: "In-app notification" → API: "in-app"
  - UI: "Text message (SMS)" → API: "sms"
  - UI: "Email" → API: "email"
  - UI: "All" → API: "all"

- The recipient type mapping:
  - UI: "Parent" → API: "Parent"
  - UI: "Teen" → API: "Teen"
  - UI: "Child" → API: "Child"

- Family members are already loaded via `FamilyViewModel`, so the recipient dropdown can use that data.

