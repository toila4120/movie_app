# Movie App

A Flutter application for browsing and watching movies.

## Features
- Browse movies by category
- Watch movies
- AI-powered movie recommendations
- User authentication
- And more...

## Environment Setup

This application uses environment variables to securely store API keys. Follow these steps to set up your environment:

1. Create a `.env` file in the root of the project
2. Add the following lines to your `.env` file:
```
# API Keys
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```
3. Replace `YOUR_GEMINI_API_KEY` with your actual Gemini API key 

Note: The `.env` file is included in `.gitignore` to prevent accidentally committing sensitive information. Never commit your API key to version control!

## Running the App

1. Make sure you have Flutter installed
2. Clone this repository
3. Set up your `.env` file as described above
4. Run `flutter pub get` to install dependencies
5. Run `flutter run` to start the app

## AI-powered Movie Recommendations

The app includes an AI assistant that recommends movies based on user preferences using Google's Gemini API.

To use this feature:
1. Navigate to the Chat tab
2. Type in your movie preferences or interests
3. The AI will analyze your input and suggest relevant movies
4. Tap on a movie card to view more details

## Security Notes

The application implements the following security practices to protect API keys:

1. API keys are stored in an environment file (`.env`) that is excluded from Git
2. The dotenv package is used to load these values at runtime
3. Validation checks ensure the API keys are properly configured
4. Clear error messages guide users when keys are missing

This approach ensures that:
- API keys aren't hardcoded in the source code
- Keys won't be inadvertently committed to Git repositories
- Each developer can use their own API keys locally
- Clear error handling exists for misconfiguration
