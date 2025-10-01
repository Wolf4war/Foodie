# Foodie - Recipe Discovery App

A responsive Vue 3 web application built with Vite, TailwindCSS, Vue Router, and Axios that uses TheMealDB API to discover and explore amazing recipes from around the world.

## 📸 Application Preview

![Foodie Homepage](./src/assets/Foodie%20Homepage.jpg)

*Beautiful, responsive design with intuitive search functionality and modern UI*

![Foodie Homepage](./docs/homepage-screenshot.png)

*Beautiful, responsive design with intuitive search functionality and modern UI*

## ✨ Key Highlights

- 🎨 **Modern Design**: Clean, responsive interface with orange gradient theme
- 🔍 **Smart Search**: Real-time meal search with autocomplete suggestions
- 📱 **Mobile-First**: Fully responsive design that works on all devices
- 🚀 **Fast Performance**: Optimized Vue 3 + Vite build for lightning-fast loading
- 🐳 **Docker Ready**: Production-ready containerization with Nginx
- 🌐 **Live Data**: Real-time data from TheMealDB API

## 🚀 Features

## ✨ Live Demo Features

- 🎨 **Modern UI/UX**: Clean, responsive design with orange gradient theme
- 🔍 **Smart Search**: Real-time meal search with instant results
- 📱 **Mobile-First**: Fully responsive across all device sizes
- 🧭 **Intuitive Navigation**: Easy-to-use header with clear routing
- 🍽️ **Rich Content**: Detailed meal information with ingredients and instructions
- 🚀 **Fast Performance**: Optimized with Vite and production-ready Docker setup

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

### Prerequisites
- **Node.js** (v18+ recommended) - [Download](https://nodejs.org/)
- **npm** or **yarn** package manager
- **Docker** (v20+) - [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (v2+) - [Install Compose](https://docs.docker.com/compose/install/)

### Development Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start development server:**
   ```bash
   npm run dev
   ```
   **Access at**: http://localhost:5173

3. **Build for production:**
   ```bash
   npm run build
   ```

4. **Preview production build:**
   ```bash
   npm run preview
   ```

### 🐳 Docker Deployment

#### Prerequisites
- Install [Docker](https://docs.docker.com/get-docker/) (v20+ recommended)
- Install [Docker Compose](https://docs.docker.com/compose/install/) (v2+)

#### Docker Setup Overview
- **Production container**: Uses Nginx to serve the optimized Vue build
- **Development container**: Runs Vite dev server with hot reload
- **Multi-stage build**: Separates build and runtime environments for smaller images

---

#### 🚀 Quick Start with Docker Compose
```bash
# Build and run production container
docker-compose up --build
```
**Access the app at**: http://localhost:8080

#### 🛠️ Manual Docker Commands
```bash
# Build the Docker image
docker build -t foodie-app .

# Run the container
docker run -d -p 8080:80 --name foodie-production foodie-app
```
**Access the app at**: http://localhost:8080

#### 💻 Development with Docker
```bash
# Run development environment (Vite hot-reload)
docker-compose --profile dev up --build foodie-dev
```
**Access the app at**: http://localhost:5173

#### 🚢 Production Features
- **Multi-stage build** for optimized image size (~50MB final image)
- **Nginx** web server with production-ready configuration
- **Vue Router history mode** support with proper fallbacks
- **Gzip compression** enabled for better performance
- **Security headers** included (X-Frame-Options, CSP, etc.)
- **Static asset caching** for improved load times
- **Health check endpoint** at `/health` for monitoring

#### 🔧 Container Management
```bash
# Check running containers
docker ps

# View logs
docker logs foodie-production

# Stop and remove containers
docker-compose down

# Rebuild after code changes
docker-compose up --build

# Test health check
curl http://localhost:8080/health
```

#### 🧪 Testing the Application
Once running, you can test all features:

1. **Search Functionality**: Try searching for "chicken", "pasta", or "cake"
2. **Categories**: Browse meal categories and click to filter meals
3. **Meal Details**: Click any meal card to view detailed recipe information
4. **Navigation**: Test responsive navigation on different screen sizes
5. **API Integration**: All data is fetched from [TheMealDB API](https://www.themealdb.com/)

**Health Check**: Visit http://localhost:8080/health (should return "healthy")

## 🎯 Live Demo Experience

Once running, you can experience the full functionality:

### 🔍 **Search Experience**
- Type "chicken", "pasta", or "cake" in the search bar
- See instant results with beautiful meal cards
- Click any meal to view detailed recipes

### 📂 **Browse Categories**
- Navigate to Categories page to see all cuisine types
- Click any category to filter meals by cuisine
- Explore different international recipes

### 📄 **Recipe Details**
- View complete ingredient lists with measurements
- Follow step-by-step cooking instructions
- Watch embedded YouTube cooking videos (when available)

## 📸 Screenshots & Demo

The application features a modern, responsive design:

- **Homepage**: Beautiful orange gradient hero section with search functionality
- **Navigation**: Clean header with star logo and responsive mobile menu
- **Search Results**: Grid-based meal cards with hover effects
- **Meal Details**: Full recipe pages with ingredients and instructions
- **Categories**: Organized browsing by meal categories

*Screenshot shows the development server running at http://localhost:5173*

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
