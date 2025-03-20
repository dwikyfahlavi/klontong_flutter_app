# Klontong - Mobile Project

**Klontong** is a mobile application designed to help a small convenience store transition into the digital age by enabling online product sales. This project demonstrates a basic CRUD (Create, Read, Update, Delete) application, with product management as its core feature.

---

## Overview

This project aims to assist a family-owned convenience store in managing and displaying products digitally. While the backend development is pending, the application uses a mocked API to simulate functionality.

## Project Stack

- **Framework:** Flutter
- **State Management:** Bloc Cubit
- **HTTP Client:** Dio
- **Local Storage:** Flutter Secure Storage (Authentication), sqflite (API Cache)
- **API Mocking:** [crudcrud.com](https://crudcrud.com/)
- **Unit Testing:** Mocktail

---

## Features

1. **Product Listing with Search & Cached Data**  
    Displays a searchable product list with cached data using sqflite, ensuring smooth scrolling and data loading.

2. **Product Details**  
    Each product includes details such as name, description, category, weight, dimensions, image, and price.

3. **Add, Update, and Delete Products**  
    Users can manage products through the app interface, with fields for name, description, category, weight, dimensions, image, and price.

4. **User Authentication (Login & Register)**  
    Users can create an account and log in to access personalized features. Authentication data is securely stored using Flutter Secure Storage.

---

## Data Schema

The product data adheres to the following schema:

```json
{
  "id": "86",
  "CategoryId": "14",
  "categoryName": "Cemilan",
  "sku": "MHZVTK",
  "name": "Ciki ciki",
  "description": "Ciki ciki yang super enak, hanya di toko klontong kami",
  "weight": 500,
  "width": 5,
  "length": 5,
  "height": 5,
  "image": "https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b",
  "harga": 30000
}
```

## Mock API

The application relies on the [crudcrud.com](https://crudcrud.com/) API for development. Since the free API has a 1-day lifespan, the endpoint URL must be regenerated daily.

### API Regeneration Steps:

1. Open a browser in **Incognito Mode**.
2. Visit [crudcrud.com](https://crudcrud.com/).
3. Generate a new API endpoint and update it in the project.


## Unit Testing

Unit tests are implemented using the **Mocktail** library to ensure code reliability. Tests focus on mocking API interactions and verifying state management logic.

---

## How to Run the Project

1. Clone the repository.
2. Update the `baseUrl` in the code with your [crudcrud.com](https://crudcrud.com/) endpoint.
3. Run the project using `flutter run`.


## Internationalization

The project is developed in English to support an international development team.

---

## License

This project is licensed under the MIT License.
