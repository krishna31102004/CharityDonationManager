# 📱 Charity Donation App

## 📌 Project Overview
The **Charity Donation App** is an iOS application built using **SwiftUI** with **MVVM architecture**. This app allows users to:
- View nearby charities and donation centers on a **map**.
- Search for donation needs based on categories.
- Track donation history and save favorite charities.
- Make secure donations using **SwiftData** for persistent storage.
- Fetch real-time donation needs from external **Web APIs**.

---

## 🚀 Features
✅ **User Authentication** - Login and registration with basic validation.  
✅ **Donation System** - Users can donate to charities and save donation history.  
✅ **Favorites List** - Users can mark charities as favorites for easy access.  
✅ **Map Integration** - View nearby charities using **MapKit** and **Google Places API**.  
✅ **Web API Integration** - Fetch real-time donation needs via Google Places API.  
✅ **MVVM Architecture** - Clean separation of concerns between **View, ViewModel, and Model**.  
✅ **Persistent Storage** - Donations and user profiles stored using **SwiftData**.  

---

## 🏗️ Project Architecture - MVVM
This project follows the **MVVM (Model-View-ViewModel)** architecture pattern.

📂 CharityDonationApp │── 📂 Models │ ├── DonationModel.swift │ ├── PlacesModel.swift │ ├── UserModel.swift │ │── 📂 ViewModels │ ├── DonationViewModel.swift │ ├── DonationHistoryViewModel.swift │ ├── DashboardViewModel.swift │ ├── PlacesViewModel.swift │ ├── ProfileViewModel.swift │ │── 📂 Views │ ├── DonationView.swift │ ├── DonationHistoryView.swift │ ├── DashboardView.swift │ ├── PlacesView.swift │ ├── ProfileView.swift │ │── 📂 Services │ ├── APIService.swift (Handles API Calls) │ ├── LocationService.swift (Handles MapKit & Google Places API) │ │── 📂 Assets │── 📂 SwiftData (For persistent storage) │── CharityDonationApp.swift (Main Entry Point)

---

## 📌 Installation
1️⃣ **Clone the repository**
git clone https://github.com/yourusername/CharityDonationApp.git
2️⃣ **Open in Xcode**
Navigate to the project folder and open kbcse335projectfinal.xcodeproj 
3️⃣ **Run the App**
Ensure you're using Xcode 15 and iOS 17 Simulator.
Click on the ▶️ Run button in Xcode.
📡 API Integration - Google Places API
The app uses Google Places API to fetch real-time information about nearby charities.
API calls are made using URLSession and JSON decoding.
Required API Key: Google Cloud Console API Key.
API Endpoint Example:
https://maps.googleapis.com/maps/api/place/nearbysearch/json?
location=latitude,longitude
&radius=5000
&type=charity
&key=YOUR_API_KEY
How to Get an API Key:
Visit Google Cloud Console.
Create a new project.
Enable Google Places API.
Generate an API key and replace YOUR_API_KEY in the app.
🗺️ Map & Location Features
The app uses MapKit and Google Places API to display nearby charities.
Users can search for charities based on their location.
Location permissions must be enabled for full functionality.
📂 Persistent Storage
All donations and user details are saved using SwiftData.
The app ensures that donation records persist even after closing the app.
🛠️ Future Improvements
🔹 Implement user authentication via Firebase.
🔹 Enhance UI/UX with animations and dark mode.
🔹 Introduce push notifications for urgent charity needs.
🔹 Improve search filters for a better user experience.

📜 License
This project is open-source and available under the MIT License.

👨‍💻 Developer
Krishna Balaji
📧 Email: krishna311004@gmail.com
🔗 GitHub: https://github.com/krishna31102004
🔗 LinkedIn: www.linkedin.com/in/krishna-balaji-53785a257

🎥 Presentation Video
📺 Watch the project demo here: https://www.youtube.com/watch?v=v4VzRtGHnG4
