# Authentication System with Node.js, MongoDB, and Flutter

This project aims to create a simple user authentication system using Node.js and MongoDB. Users can register and log in through a Flutter mobile app. After logging in, users can securely authenticate their sessions using JWT (JSON Web Token).

## Technologies

- **Backend**: Node.js, Express, MongoDB
- **Database**: MongoDB
- **Authentication**: JWT (JSON Web Token)
- **Frontend**: Flutter (Login and Register Screens)

## Folder Structure
```bash
/client              # Flutter frontend
/server              # Node.js backend
```

## Installation

### 1. Backend (Node.js and MongoDB)

1. **Navigate to the server folder**:
   ```bash
   cd server
   
2. **Install necessary packages**:
    ```bash
    npm install
    
3. **Create and configure the .env file**:
 - Create a .env file in the server/ folder and configure it as follows:
    ```bash
    PORT=3000
    MONGODB_URL=mongodb://YOUR_MONGODB_URL
    JWT_SECRET=YOUR_SECRET_KEY
- PORT: The port the server will run on.
- MONGODB_URL: MongoDB connection URL (use the IP address of your MongoDB server).
- JWT_SECRET: The secret key to sign JWT tokens.

4. **Start the backend**:
    ```bash
    npm start
- The server will run by default on ```http://localhost:3000```.

### 2. Frontend (Flutter)

1. **Navigate to the client folder**:
   ```bash
   cd client

2. **Install necessary packages**:
    ```bash
    flutter pub get

3. **Configure the lib/core/env/env.dart file**:
- In this file, you need to specify the IP address of your backend server. Configure it as follows and replace YOUR_IP_ADDRESS with your backend server's IP address:
    ```bash
    class Environment {
  static const String baseUrl = 'http://YOUR_IP_ADDRESS:3000/api/user';
  }

4. **Run the Flutter app**:
    ```bash
    flutter run

