# Foodie - Recipe Discovery App

A responsive Vue 3 web application built with Vite, TailwindCSS, Vue Router, and Axios that uses TheMealDB API to discover and explore amazing recipes from around the world.

## 🚀 Features

### Home Page
- **Search Functionality**: Search meals by name with real-time results
- **Responsive Design**: Fully responsive grid layout for meal cards
- **Quick Suggestions**: Pre-defined search suggestions for better UX
- **Loading & Error States**: Graceful handling of loading and error scenarios

### Categories Page  
- **Browse by Category**: Explore all available meal categories
- **Category Cards**: Beautiful cards showing category images and descriptions
- **Direct Navigation**: Click to view all meals within a category

### Meal Details Page
- **Comprehensive View**: Large images, detailed instructions, and ingredients
- **Ingredients List**: Complete ingredients with measurements
- **Video Tutorial**: Embedded YouTube videos when available
- **Responsive Layout**: Mobile-first design that adapts to desktop
- **Quick Links**: Navigate to related categories or random meals

### Category Meals Page
- **Filtered Results**: View all meals within a specific category
- **Consistent UI**: Same meal card design for familiarity

## 🛠️ Tech Stack

- **Vue 3** - Progressive JavaScript framework
- **Vite** - Fast build tool and dev server
- **Vue Router** - Client-side routing
- **Axios** - HTTP client for API requests  
- **TailwindCSS** - Utility-first CSS framework
- **TheMealDB API** - Free recipe database API

## 📱 Responsive Design

The application is built with a mobile-first approach:
- **Mobile**: Single column layout, stacked content
- **Tablet**: 2-3 column grids, optimized touch targets
- **Desktop**: 4+ column grids, hover effects, larger content areas

## 🎨 Component Architecture

### Reusable Components
- `SearchBar.vue` - Search input with validation
- `MealCard.vue` - Reusable meal display card
- `LoadingSpinner.vue` - Loading state indicator
- `ErrorMessage.vue` - Error handling with retry functionality
- `AppNavigation.vue` - Responsive navigation header

### Views/Pages
- `Home.vue` - Search and results page
- `Categories.vue` - Category browsing page
- `CategoryMeals.vue` - Meals filtered by category
- `MealDetails.vue` - Detailed meal information

### Services
- `api.js` - Centralized API service layer

## 🚦 Routes

- `/` - Home page with search functionality
- `/categories` - Browse all meal categories  
- `/category/:category` - View meals in specific category
- `/meal/:id` - Detailed meal information

## 📡 API Integration

Uses TheMealDB API endpoints:
- `/search.php?s=` - Search meals by name
- `/lookup.php?i=ID` - Get meal details by ID
- `/categories.php` - Get all categories
- `/filter.php?c=Category` - Filter meals by category
- `/random.php` - Get random meal

## 🎯 Key Features Implemented

### State Management
- Loading states with beautiful spinners
- Error handling with retry functionality
- Responsive search with debouncing
- Route parameter watching

### User Experience
- Smooth hover animations and transitions
- Consistent color scheme (orange/red gradient theme)
- Accessible navigation with keyboard support
- Progressive image loading with lazy loading

### Performance
- Component-based architecture for reusability
- Efficient API calls with error handling
- Optimized images with proper sizing
- Fast client-side routing

## 🚀 Getting Started

### Development Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start development server:**
   ```bash
   npm run dev
   ```

3. **Build for production:**
   ```bash
   npm run build
   ```

4. **Preview production build:**
   ```bash
   npm run preview
   ```

### 🐳 Docker Deployment

#### Quick Start with Docker Compose
```bash
# Build and run production container
docker-compose up --build

# Access the app at http://localhost:8080
```

#### Manual Docker Commands
```bash
# Build the Docker image
docker build -t foodie-app .

# Run the container
docker run -d -p 8080:80 --name foodie-production foodie-app

# Access the app at http://localhost:8080
```

#### Development with Docker
```bash
# Run development environment
docker-compose --profile dev up --build foodie-dev

# Access the app at http://localhost:5173
```

### 🚢 Production Features
- **Multi-stage build** for optimized image size
- **Nginx** web server with optimized configuration
- **Vue Router history mode** support with proper fallbacks
- **Gzip compression** enabled for better performance
- **Security headers** included
- **Static asset caching** for improved load times
- **Health check endpoint** at `/health`

## 🌟 Future Enhancements

- Add favorites functionality with local storage
- Implement meal planning features  
- Add shopping list generation from ingredients
- Include nutritional information display
- Add user ratings and reviews
- Implement advanced filtering (dietary restrictions, etc.)

## 📄 License

This project is built for educational purposes using the free TheMealDB API.

---

Made with ❤️ by Wolf4war - **Foodie: Where recipes come to life!**
