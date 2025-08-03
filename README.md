# GroceryApp - Flutter Grocery Shopping App

A comprehensive Flutter grocery shopping application with complete user flow including authentication, product browsing, cart management, order placement, and order tracking.

## Features

### 🔐 Authentication
- **User Registration**: Create new accounts with email, password, and optional profile information
- **User Login**: Secure login with email and password
- **Profile Management**: View and update user profile information
- **Session Management**: Persistent login state with local storage

### 🛍️ Product Browsing
- **Category-based Browsing**: Browse products by categories (Fruits & Vegetables, Dairy & Eggs, Meat & Seafood, etc.)
- **Product Details**: Detailed product information with descriptions, ratings, and pricing
- **Discount Support**: Products with discount pricing and promotional badges
- **Stock Management**: Real-time stock status and availability

### 🔍 Search Functionality
- **Real-time Search**: Instant search results as you type
- **Category Search**: Quick search by product categories
- **Popular Searches**: Suggested search terms for better discovery
- **Advanced Filtering**: Search by product name, description, category, and tags

### 🛒 Cart Management
- **Add to Cart**: Easy one-tap add to cart functionality
- **Quantity Management**: Adjust item quantities with intuitive controls
- **Cart Persistence**: Cart items saved locally across app sessions
- **Price Calculations**: Real-time subtotal, tax, and delivery fee calculations
- **Free Delivery**: Automatic free delivery for orders over $50

### 📦 Order Management
- **Order Placement**: Seamless checkout process with delivery address
- **Order History**: Complete order history with status tracking
- **Order Tracking**: Real-time order status updates (Pending → Confirmed → Preparing → Shipped → Delivered)
- **Order Details**: Comprehensive order information and item breakdown
- **Order Cancellation**: Cancel orders when eligible

### 🚚 Order Status Tracking
- **Status Updates**: Visual progress tracking with timeline
- **Delivery Estimates**: Estimated delivery dates and times
- **Tracking Numbers**: Unique tracking numbers for each order
- **Delivery Notifications**: Status change notifications

## Technical Features

### 🏗️ Architecture
- **Clean Architecture**: Separation of concerns with proper layering
- **State Management**: Provider pattern for reactive state management
- **Local Storage**: SharedPreferences for data persistence
- **JSON Serialization**: Automated model serialization/deserialization

### 🎨 UI/UX
- **Material Design 3**: Modern Material Design components
- **Google Fonts**: Beautiful typography with Poppins font family
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Custom Widgets**: Reusable components for consistent design
- **Beautiful Animations**: Smooth transitions and interactions

### 📱 User Experience
- **Intuitive Navigation**: Bottom tab navigation with badges
- **Loading States**: Proper loading indicators throughout the app
- **Error Handling**: Graceful error handling with user feedback
- **Empty States**: Helpful empty states with call-to-action buttons
- **Form Validation**: Comprehensive form validation with clear error messages

## Project Structure

```
lib/
├── models/              # Data models
│   ├── user.dart
│   ├── product.dart
│   ├── cart_item.dart
│   └── order.dart
├── services/            # Business logic and API services
│   ├── auth_service.dart
│   ├── product_service.dart
│   ├── cart_service.dart
│   └── order_service.dart
├── providers/           # State management
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   └── order_provider.dart
├── screens/             # UI screens
│   ├── auth/
│   ├── home/
│   ├── products/
│   ├── search/
│   ├── cart/
│   ├── checkout/
│   ├── orders/
│   └── profile/
├── widgets/             # Reusable widgets
│   ├── product_card.dart
│   ├── cart_item_card.dart
│   ├── order_card.dart
│   ├── category_chip.dart
│   └── main_navigation.dart
└── main.dart           # App entry point
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd grocery_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1           # State management
  http: ^1.1.2               # HTTP requests
  shared_preferences: ^2.2.2  # Local storage
  google_fonts: ^6.1.0       # Typography
  go_router: ^12.1.3         # Navigation
  json_annotation: ^4.8.1    # JSON serialization
  uuid: ^4.2.1               # Unique IDs

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
```

## Getting Started

### First Time Setup
1. Launch the app
2. Create a new account by tapping "Sign Up"
3. Fill in your registration details
4. Start browsing products and adding items to your cart
5. Proceed to checkout when ready
6. Track your order in the Orders tab

### Demo Data
The app includes mock data for:
- 10+ sample products across different categories
- Simulated order status updates
- Local data persistence for testing

### User Flow
1. **Authentication**: Register or login to access the app
2. **Browse Products**: Explore products by category or use search
3. **Add to Cart**: Select products and add them to your cart
4. **Checkout**: Review cart, enter delivery address, and place order
5. **Track Orders**: Monitor order status and delivery progress

## Features in Detail

### Authentication System
- Secure local authentication with encrypted storage
- Form validation with real-time feedback
- Password strength requirements
- Optional profile information (phone, address)

### Product Catalog
- Rich product information with ratings and reviews
- Category-based organization
- Discount and promotional pricing
- Stock availability tracking
- Image placeholder system ready for actual product images

### Shopping Cart
- Persistent cart across app sessions
- Real-time price calculations
- Free delivery threshold ($50+)
- Tax calculation (8%)
- Easy quantity adjustments

### Order Processing
- Comprehensive checkout flow
- Order confirmation with tracking numbers
- Simulated order status progression
- Order history with filtering options
- Detailed order tracking with progress timeline

## Customization

### Adding New Categories
Update the categories list in `lib/services/product_service.dart`:

```dart
static final List<String> _categories = [
  'All',
  'Your New Category',
  // ... existing categories
];
```

### Adding New Products
Add products to the mock data in `lib/services/product_service.dart`:

```dart
Product(
  id: 'unique_id',
  name: 'Product Name',
  description: 'Product description',
  price: 9.99,
  category: 'Category Name',
  imageUrl: 'image_url',
  // ... other properties
),
```

### Styling Customization
Modify the theme in `lib/main.dart` to customize colors, fonts, and component styles.

## Future Enhancements

- **Real Backend Integration**: Replace mock services with actual API calls
- **Payment Processing**: Integrate payment gateways
- **Push Notifications**: Real-time order status notifications
- **Product Images**: Add actual product image loading
- **Favorites**: Save favorite products
- **Reviews**: User product reviews and ratings
- **Delivery Tracking**: Real-time GPS delivery tracking
- **Social Features**: Share products and orders

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository or contact the development team.

---

**Built with ❤️ using Flutter and Dart**