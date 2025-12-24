
### **What is MentorVerse?**

**MentorVerse** is a cross-platform mobile application (iOS and Android) designed to democratize access to professional mentorship. Unlike casual networking platforms (like LinkedIn) or web-only solutions, MentorVerse is built as a **mobile-first** solution that prioritizes **structured, developmental relationships**.

The core philosophy of the app is that mentorship should not just be a "chat"; it must be **goal-oriented**. The app distinguishes itself by building the entire user experience around defining goals, tracking percentage-based progress, and ensuring mentors can actively monitor and support that growth.

---

### **Full Feature Breakdown**

The application is divided into six major functional areas. Below is the complete list of features as detailed in the thesis requirements.

#### **1. User Management & Profiles**

* **Authentication:** Secure registration and login using email and password .
* **Dual-Role Support:** Users can sign up as a **Mentor**, a **Mentee**, or **Both** .
* **Profile Management:**
* **Mentors:** Display their bio, "Area of Expertise," "Years of Experience," and current availability status .
* **Mentees:** Display their "Area of Interest" and specific learning goals .
* **Skills:** Both users can tag themselves with specific skills (e.g., Python, Project Management) to aid in matching .



#### **2. Mentor Discovery (Finding a Match)**

* **Search & Filter:** Mentees can search for mentors by name, specific expertise, or broader professional fields .
* **Rich Profiles:** Mentees can view detailed mentor profiles, including their experience levels and ratings, to assess compatibility .
* **Bookmarking:** Mentees can "bookmark" (save) interesting mentor profiles to review later before sending a formal request .

#### **3. Connection Workflow**

* **Formal Requests:** Connecting isn't automatic. A mentee must send a **Mentorship Request** .
* **Accept/Decline:** The mentor receives a real-time notification and can view the request. They have the power to **Accept** or **Decline** the relationship based on their capacity or fit .
* **Relationship Management:** Users can view a list of all active mentorships and have the ability to formally **end** a mentorship if needed .

#### **4. Goal Setting & Progress Tracking (The Core Feature)**

This is the application's most critical differentiator, designed to provide structure .

* **Create Goals:** Mentees create specific "Development Goals" that include a title, description, category (Career, Skill, Personal), and a target **deadline** .
* **Visual Progress Bars:** Mentees manually update their progress (e.g., moving from 20% to 50%). This updates a visual progress bar on the dashboard .
* **Real-Time Monitoring:** Mentors can view their mentees' goals and see these progress updates happen in real-time .
* **Feedback/Comments:** Mentors can leave specific comments on a goal to provide feedback, encouragement, or course correction .
* **Completion:** Mentees mark goals as "Complete," triggering a celebration/completion state in the app .

#### **5. Communication (Messaging)**

* **In-App Chat:** A built-in text messaging system allows mentors and mentees to communicate without leaving the app .
* **Real-Time Delivery:** Messages are delivered instantly using WebSockets (Supabase Realtime) .
* **Push Notifications:** Users receive alerts on their phone for new messages or requests even when the app is closed .
* **History:** The app maintains a full history of the conversation .
* *(Note: The thesis lists "Read Receipts" and "Typing Indicators" as features , though your chat history suggests you may wish to disable these.)*



#### **6. Dashboards & Analytics**

* **Mentee Dashboard:** A personalized home screen showing active mentorships, a summary of active goals, and recent messages .
* **Mentor Dashboard:** A management view showing a list of current mentees, pending connection requests that need action, and goals that require review .
* **Reviews & Ratings:** Mentees can rate their experience and write reviews for mentors, which aids the community in finding quality guidance .