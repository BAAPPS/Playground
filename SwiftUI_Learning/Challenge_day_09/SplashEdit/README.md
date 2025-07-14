# Challenge Day 9 – SplashEdit

SplashEdit is a full-stack SwiftUI challenge project that blends creative image editing with modern backend integration and robust offline-first architecture. Users can explore photos from Unsplash, apply stunning Core 
Image filters, and save both filtered and original images locally with SwiftData. All content is securely synced to the cloud using Supabase, complete with user authentication, secure access policies, and personalized 
features like favorites and collections. Whether online or offline, SplashEdit delivers a seamless experience that combines artistry, data management, and scalable cloud connectivity — making it the perfect real-world 
challenge to level up your iOS development skills.

---

## Features

* Email-based **user authentication** via **Supabase Auth**
* Secure, user-specific access using **Row Level Security (RLS) policies**
* Public view of recent signups using a **Supabase SQL view**
* Display of signed-in user's **username**, **email**, and **sign-in timestamp**
* **Unsplash API integration** to fetch high-quality, searchable images
* Apply **Core Image filters** with real-time preview and save both filtered and original versions
* Store images and metadata **locally with SwiftData** using `@Model` and `@Query`
* Sync saved images and metadata to **Supabase Storage** and **Postgres**
* Save **likes** and create a **personal collection** of favorites across sessions
* View and manage liked photos in a dedicated **"My Collection"** screen
* **Offline-first design**: all data is available offline, syncing resumes when network is restored
* Real-time **user count** and global data view using Supabase queries
* **Reactive UI** architecture using `@Observable` view models and **SwiftUI**
* Filtering and sorting of local photo data with **predicates** and **sort descriptors**
* Automatic **profile updates** across views via **NotificationCenter** broadcasting
* **Network monitoring** to dynamically adapt between online and offline states

---

## Why This Challenge?

This challenge goes beyond local app development — it introduces real-world skills like:

* Building **offline-resilient apps**
* Creating **photo editing tools** using Core Image
* Syncing between **local and cloud storage**
* Working with **RESTful APIs** (Unsplash) and **Postgres SQL** (Supabase)
* Designing for **user personalization** (likes, filtered versions, collections)
* Managing **authentication, secure access**, and **live user data**

It’s not just a coding exercise — it’s a real app foundation.

---

## What I Learned


---

## Challenges and Problems Encountered
