import '../features/shop/models/banner_model.dart';
import '../features/shop/models/brand_model.dart';
import '../features/shop/models/category_model.dart';
import '../features/shop/models/product_attribute_model.dart';
import '../features/shop/models/product_model.dart';
import '../features/shop/models/product_variation_model.dart';
import '../utils/constants/image_strings.dart';

class TDummyData {
  /// -- Banners
  static final List<BannerModel> banners = [
    BannerModel(id: '1', imageUrl: SImages.promoBanner1, targetScreen: '/order', active: true),
    BannerModel(id: '2', imageUrl: SImages.promoBanner2, targetScreen: '/cart', active: true),
    BannerModel(id: '3', imageUrl: SImages.promoBanner3, targetScreen: '/store', active: true),
    BannerModel(id: '4', imageUrl: SImages.banner1, targetScreen: '/cart', active: true),
    BannerModel(id: '5', imageUrl: SImages.banner2, targetScreen: '/order', active: true),
    BannerModel(id: '6', imageUrl: SImages.banner3, targetScreen: '/store', active: true),
    BannerModel(id: '7', imageUrl: SImages.banner4, targetScreen: '/cart', active: true),
  ];

  /// -- Brands
  static final List<BrandModel> brands = [
    BrandModel(id: '1', image: SImages.nikeLogo, name: 'Nike', productsCount: 265, isFeatured: true),
    BrandModel(id: '2', image: SImages.adidasLogo, name: 'Adidas', productsCount: 95, isFeatured: true),
    BrandModel(id: '3', image: SImages.jordanLogo, name: 'Jordan', productsCount: 36, isFeatured: true),
    BrandModel(id: '4', image: SImages.pumaLogo, name: 'Puma', productsCount: 65, isFeatured: true),
    BrandModel(id: '5', image: SImages.appleLogo, name: 'Apple', productsCount: 16, isFeatured: true),
    BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
    BrandModel(id: '7', image: SImages.kenwoodLogo, name: 'Kenwood', productsCount: 36, isFeatured: false),
    BrandModel(id: '8', image: SImages.acerlogo, name: 'Acer', productsCount: 12, isFeatured: false),
    BrandModel(id: '9', image: SImages.ikeaLogo, name: 'IKEA', productsCount: 42, isFeatured: true),
    BrandModel(id: '10', image: SImages.hermanMillerLogo, name: 'Herman Miller', productsCount: 18, isFeatured: false),
  ];

  /// -- Categories
  static final List<CategoryModel> categories = [
    CategoryModel(id: '1', image: SImages.sportIcon, name: 'Sports', isFeatured: true),
    CategoryModel(id: '2', image: SImages.electronicsIcon, name: 'Electronics', isFeatured: true),
    CategoryModel(id: '3', image: SImages.clothIcon, name: 'Clothes', isFeatured: true),
    CategoryModel(id: '4', image: SImages.animalIcon, name: 'Animals', isFeatured: true),
    CategoryModel(id: '5', image: SImages.furnitureIcon, name: 'Furniture', isFeatured: true),
    CategoryModel(id: '6', image: SImages.shoeIcon, name: 'Shoes', isFeatured: true),
    CategoryModel(id: '7', image: SImages.cosmeticsIcon, name: 'Cosmetics', isFeatured: true),

    // Subcategories
    CategoryModel(id: '8', image: SImages.sportIcon, name: 'Sport Shoes', parentId: '1', isFeatured: false),
    CategoryModel(id: '9', image: SImages.sportIcon, name: 'Track suits', parentId: '1', isFeatured: false),
    CategoryModel(id: '10', image: SImages.sportIcon, name: 'Sports Equipments', parentId: '1', isFeatured: false),

    CategoryModel(id: '11', image: SImages.furnitureIcon, name: 'Bedroom furniture', parentId: '5', isFeatured: false),
    CategoryModel(id: '12', image: SImages.furnitureIcon, name: 'Kitchen furniture', parentId: '5', isFeatured: false),
    CategoryModel(id: '13', image: SImages.furnitureIcon, name: 'Office furniture', parentId: '5', isFeatured: false),

    CategoryModel(id: '14', image: SImages.electronicsIcon, name: 'Laptop', parentId: '2', isFeatured: false),
    CategoryModel(id: '16', image: SImages.electronicsIcon, name: 'Mobile', parentId: '2', isFeatured: false),

    CategoryModel(id: '17', image: SImages.clothIcon, name: 'Shirts', parentId: '3', isFeatured: false),

    // Shoes Subcategories
    CategoryModel(id: '18', image: SImages.shoeIcon, name: 'Sports Shoes', parentId: '6', isFeatured: false),
    CategoryModel(id: '19', image: SImages.shoeIcon, name: 'Sneakers & Casuals', parentId: '6', isFeatured: false),
    CategoryModel(id: '20', image: SImages.shoeIcon, name: 'Slippers & Slides', parentId: '6', isFeatured: false),

    // Animals Subcategories
    CategoryModel(id: '21', image: SImages.animalIcon, name: 'Pet Food', parentId: '4', isFeatured: false),

    // Cosmetics Subcategories
    CategoryModel(id: '22', image: SImages.cosmeticsIcon, name: 'Skincare', parentId: '7', isFeatured: false),
    CategoryModel(id: '23', image: SImages.cosmeticsIcon, name: 'Perfumes & Body', parentId: '7', isFeatured: false),
  ];

  /// -- Products
  static final List<ProductModel> products = [
    // 001 - Nike
    ProductModel(
      id: '001',
      title: 'Green Nike Sports Shoe',
      stock: 15,
      price: 135,
      isFeatured: true,
      thumbnail: SImages.productImage1,
      description: 'Green Nike sports shoes for running and daily workouts with responsive cushioning.',
      brand: BrandModel(id: '1', image: SImages.nikeLogo, name: 'Nike', productsCount: 265, isFeatured: true),
      images: [SImages.productImage1, SImages.productImage23, SImages.productImage21],
      salePrice: 120,
      sku: 'ABR4568',
      categoryId: '8',
      productType: 'variable',
      productAttributes: [
        ProductAttributeModel(name: 'Color', values: ['Green', 'Black', 'Red']),
        ProductAttributeModel(name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
      ],
      productVariations: [
        ProductVariationModel(
          id: '1',
          stock: 16,
          price: 135,
          salePrice: 122.6,
          image: SImages.productImage1,
          description: 'Green Nike sports shoes with flexible cushioned sole.',
          attributeValues: {'Color': 'Green', 'Size': 'EU 34'},
        ),
        ProductVariationModel(
          id: '2',
          stock: 15,
          price: 132,
          image: SImages.productImage23,
          description: 'Black Nike sports running shoes with durable grip.',
          attributeValues: {'Color': 'Black', 'Size': 'EU 32'},
        ),
        ProductVariationModel(
          id: '3',
          stock: 0,
          price: 140,
          image: SImages.productImage21,
          description: 'Red Nike sports shoes (Currently Out of Stock).',
          attributeValues: {'Color': 'Red', 'Size': 'EU 30'},
        ),
        ProductVariationModel(
          id: '4',
          stock: 8,
          price: 135,
          image: SImages.productImage1,
          description: 'Green Nike sports shoes in size EU 32.',
          attributeValues: {'Color': 'Green', 'Size': 'EU 32'},
        ),
        ProductVariationModel(
          id: '5',
          stock: 12,
          price: 132,
          image: SImages.productImage23,
          description: 'Black Nike sports shoes in size EU 34.',
          attributeValues: {'Color': 'Black', 'Size': 'EU 34'},
        ),
        ProductVariationModel(
          id: '6',
          stock: 6,
          price: 140,
          image: SImages.productImage21,
          description: 'Red Nike sports shoes in size EU 34.',
          attributeValues: {'Color': 'Red', 'Size': 'EU 34'},
        ),
      ],
    ),

    // 002 - Zara
    ProductModel(
      id: '002',
      title: 'Blue T-Shirt for Men',
      stock: 15,
      price: 35,
      isFeatured: true,
      thumbnail: SImages.productImage54,
      description: 'Comfortable blue cotton t-shirt with modern slim fit cut.',
      brand: BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
      images: [SImages.productImage54, SImages.productImage55],
      salePrice: 25,
      sku: 'ABR4569',
      categoryId: '17',
      productType: 'single',
    ),

    // 003 - Zara
    ProductModel(
      id: '003',
      title: 'Leather Brown Jacket',
      stock: 10,
      price: 199,
      isFeatured: true,
      thumbnail: SImages.productImage64,
      description: 'Premium quality brown genuine leather jacket for winter.',
      brand: BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
      images: [SImages.productImage64, SImages.productImage65, SImages.productImage66, SImages.productImage67],
      salePrice: 150,
      sku: 'ABR4570',
      categoryId: '17',
      productType: 'single',
    ),

    // 004 - Jordan
    ProductModel(
      id: '004',
      title: 'Nike Air Jordan High Top',
      stock: 8,
      price: 220,
      isFeatured: true,
      thumbnail: SImages.productImage7,
      description: 'Iconic Nike Air Jordan classic sneakers with premium build.',
      brand: BrandModel(id: '3', image: SImages.jordanLogo, name: 'Jordan', productsCount: 36, isFeatured: true),
      images: [SImages.productImage7, SImages.productImage8, SImages.productImage9, SImages.productImage10],
      salePrice: 180,
      sku: 'ABR4571',
      categoryId: '8',
      productType: 'single',
    ),

    // 005 - Acer
    ProductModel(
      id: '005',
      title: 'Acer Nitro Gaming Laptop',
      stock: 5,
      price: 999,
      isFeatured: true,
      thumbnail: SImages.productImage47,
      description: 'High performance gaming laptop with fast refresh rate display.',
      brand: BrandModel(id: '8', image: SImages.acerlogo, name: 'Acer', productsCount: 12, isFeatured: true),
      images: [SImages.productImage47, SImages.productImage48, SImages.productImage49, SImages.productImage50],
      salePrice: 899,
      sku: 'ABR4572',
      categoryId: '14',
      productType: 'single',
    ),

    // 006 - Adidas
    ProductModel(
      id: '006',
      title: 'Adidas Black Tracksuit',
      stock: 20,
      price: 85,
      isFeatured: true,
      thumbnail: SImages.productImage24,
      description: 'Original Adidas athletic tracksuit for gym and outdoor training.',
      brand: BrandModel(id: '2', image: SImages.adidasLogo, name: 'Adidas', productsCount: 95, isFeatured: true),
      images: [SImages.productImage24, SImages.productImage25, SImages.productImage26, SImages.productImage27],
      salePrice: 65,
      sku: 'ABR4573',
      categoryId: '9',
      productType: 'single',
    ),

    // 007 - Nike
    ProductModel(
      id: '007',
      title: 'Nike Air Max 270 Running Shoes',
      stock: 18,
      price: 160,
      isFeatured: true,
      thumbnail: SImages.productImage21,
      description: 'Breathable mesh sports shoes engineered for running performance with max air cushioning.',
      brand: BrandModel(id: '1', image: SImages.nikeLogo, name: 'Nike', productsCount: 265, isFeatured: true),
      images: [SImages.productImage21, SImages.productImage22],
      salePrice: 130,
      sku: 'ABR4574',
      categoryId: '8',
      productType: 'single',
    ),

    // 008 - Nike
    ProductModel(
      id: '008',
      title: 'Nike Wildhorse Trail Runners',
      stock: 14,
      price: 145,
      isFeatured: true,
      thumbnail: SImages.productImage23,
      description: 'Durable trail running shoes with rugged traction lugs for challenging terrains.',
      brand: BrandModel(id: '1', image: SImages.nikeLogo, name: 'Nike', productsCount: 265, isFeatured: true),
      images: [SImages.productImage23, SImages.productImage1],
      salePrice: 115,
      sku: 'ABR4575',
      categoryId: '8',
      productType: 'single',
    ),

    // 009 - Adidas
    ProductModel(
      id: '009',
      title: 'Adidas Pro Official Match Football',
      stock: 25,
      price: 45,
      isFeatured: true,
      thumbnail: SImages.productImage28,
      description: 'Seamless FIFA certified match football with superior flight stability.',
      brand: BrandModel(id: '2', image: SImages.adidasLogo, name: 'Adidas', productsCount: 95, isFeatured: true),
      images: [SImages.productImage28],
      salePrice: 35,
      sku: 'ABR4576',
      categoryId: '10',
      productType: 'single',
    ),

    // 010 - Jordan
    ProductModel(
      id: '010',
      title: 'Air Jordan 1 Low Royal Blue',
      stock: 12,
      price: 175,
      isFeatured: true,
      thumbnail: SImages.productImage19,
      description: 'Low top classic basketball sneakers featuring iconic royal blue accents and leather build.',
      brand: BrandModel(id: '3', image: SImages.jordanLogo, name: 'Jordan', productsCount: 36, isFeatured: true),
      images: [SImages.productImage19, SImages.productImage20],
      salePrice: 145,
      sku: 'ABR4577',
      categoryId: '8',
      productType: 'single',
    ),

    // 011 - Puma
    ProductModel(
      id: '011',
      title: 'Puma Casual Comfort Slippers',
      stock: 30,
      price: 40,
      isFeatured: true,
      thumbnail: SImages.productImage6,
      description: 'Ultra-light cushioned slide sandals for post-workout recovery and casual wear.',
      brand: BrandModel(id: '4', image: SImages.pumaLogo, name: 'Puma', productsCount: 65, isFeatured: true),
      images: [SImages.productImage6, SImages.productImage74, SImages.productImage75],
      salePrice: 28,
      sku: 'ABR4578',
      categoryId: '8',
      productType: 'single',
    ),

    // 012 - Puma
    ProductModel(
      id: '012',
      title: 'Puma Athletic Tennis Racket',
      stock: 10,
      price: 120,
      isFeatured: true,
      thumbnail: SImages.productImage31,
      description: 'Lightweight graphite tennis racket offering exceptional spin, stability, and power.',
      brand: BrandModel(id: '4', image: SImages.pumaLogo, name: 'Puma', productsCount: 65, isFeatured: true),
      images: [SImages.productImage31],
      salePrice: 95,
      sku: 'ABR4579',
      categoryId: '10',
      productType: 'single',
    ),

    // 013 - Apple
    ProductModel(
      id: '013',
      title: 'iPhone 14 Pro Max 256GB',
      stock: 8,
      price: 1199,
      isFeatured: true,
      thumbnail: SImages.productImage52,
      description: 'Dynamic Island, 48MP main camera, Always-On Super Retina display and ultra-fast A16 Bionic.',
      brand: BrandModel(id: '5', image: SImages.appleLogo, name: 'Apple', productsCount: 16, isFeatured: true),
      images: [SImages.productImage52, SImages.productImage51, SImages.productImage53],
      salePrice: 1099,
      sku: 'ABR4580',
      categoryId: '16',
      productType: 'single',
    ),

    // 014 - Apple
    ProductModel(
      id: '014',
      title: 'iPhone 12 Super Retina OLED',
      stock: 16,
      price: 699,
      isFeatured: true,
      thumbnail: SImages.productImage71,
      description: 'Brilliant 6.1-inch Super Retina XDR display, Ceramic Shield front, and dual-camera system.',
      brand: BrandModel(id: '5', image: SImages.appleLogo, name: 'Apple', productsCount: 16, isFeatured: true),
      images: [SImages.productImage71, SImages.productImage70, SImages.productImage72, SImages.productImage73],
      salePrice: 599,
      sku: 'ABR4581',
      categoryId: '16',
      productType: 'variable',
      productAttributes: [
        ProductAttributeModel(name: 'Color', values: ['Blue', 'Red', 'Green', 'Black']),
      ],
      productVariations: [
        ProductVariationModel(
          id: 'v1',
          stock: 5,
          price: 699,
          salePrice: 599,
          image: SImages.productImage71,
          description: 'iPhone 12 in Pacific Blue.',
          attributeValues: {'Color': 'Blue'},
        ),
        ProductVariationModel(
          id: 'v2',
          stock: 4,
          price: 699,
          salePrice: 599,
          image: SImages.productImage70,
          description: 'iPhone 12 in Product Red.',
          attributeValues: {'Color': 'Red'},
        ),
        ProductVariationModel(
          id: 'v3',
          stock: 3,
          price: 699,
          salePrice: 599,
          image: SImages.productImage72,
          description: 'iPhone 12 in Light Green.',
          attributeValues: {'Color': 'Green'},
        ),
        ProductVariationModel(
          id: 'v4',
          stock: 4,
          price: 699,
          salePrice: 599,
          image: SImages.productImage73,
          description: 'iPhone 12 in Space Black.',
          attributeValues: {'Color': 'Black'},
        ),
      ],
    ),

    // 015 - Zara
    ProductModel(
      id: '015',
      title: 'Classic Pique Polo Shirt',
      stock: 22,
      price: 45,
      isFeatured: true,
      thumbnail: SImages.productImage60,
      description: 'Fine cotton pique collar polo shirt designed with breathable fabric and tailored fit.',
      brand: BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
      images: [SImages.productImage60, SImages.productImage61, SImages.productImage62, SImages.productImage63],
      salePrice: 35,
      sku: 'ABR4582',
      categoryId: '17',
      productType: 'variable',
      productAttributes: [
        ProductAttributeModel(name: 'Color', values: ['Red', 'Yellow', 'Green', 'Blue']),
      ],
      productVariations: [
        ProductVariationModel(
          id: 'pv1',
          stock: 6,
          price: 45,
          salePrice: 35,
          image: SImages.productImage60,
          description: 'Polo Shirt in vibrant Red.',
          attributeValues: {'Color': 'Red'},
        ),
        ProductVariationModel(
          id: 'pv2',
          stock: 5,
          price: 45,
          salePrice: 35,
          image: SImages.productImage61,
          description: 'Polo Shirt in warm Yellow.',
          attributeValues: {'Color': 'Yellow'},
        ),
        ProductVariationModel(
          id: 'pv3',
          stock: 5,
          price: 45,
          salePrice: 35,
          image: SImages.productImage62,
          description: 'Polo Shirt in olive Green.',
          attributeValues: {'Color': 'Green'},
        ),
        ProductVariationModel(
          id: 'pv4',
          stock: 6,
          price: 45,
          salePrice: 35,
          image: SImages.productImage63,
          description: 'Polo Shirt in navy Blue.',
          attributeValues: {'Color': 'Blue'},
        ),
      ],
    ),

    // 016 - Zara
    ProductModel(
      id: '016',
      title: 'Slim Fit Denim Jeans',
      stock: 14,
      price: 65,
      isFeatured: true,
      thumbnail: SImages.productImage4,
      description: 'Everyday comfortable slim fit denim jeans featuring durable stitching and vintage wash.',
      brand: BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
      images: [SImages.productImage4],
      salePrice: 49,
      sku: 'ABR4583',
      categoryId: '17',
      productType: 'single',
    ),

    // 017 - Kenwood
    ProductModel(
      id: '017',
      title: 'Tomi Complete Dog & Pet Food',
      stock: 35,
      price: 30,
      isFeatured: true,
      thumbnail: SImages.productImage18,
      description: 'Nutritious balanced dry food formulated with essential vitamins and minerals for active pets.',
      brand: BrandModel(id: '7', image: SImages.kenwoodLogo, name: 'Kenwood', productsCount: 36, isFeatured: false),
      images: [SImages.productImage18],
      salePrice: 22,
      sku: 'ABR4584',
      categoryId: '4',
      productType: 'single',
    ),

    // 018 - Kenwood
    ProductModel(
      id: '018',
      title: 'Stainless Steel Kitchen Prep Counter',
      stock: 6,
      price: 350,
      isFeatured: true,
      thumbnail: SImages.productImage36,
      description: 'Commercial grade stainless steel kitchen worktable with lower storage shelf and anti-slip feet.',
      brand: BrandModel(id: '7', image: SImages.kenwoodLogo, name: 'Kenwood', productsCount: 36, isFeatured: false),
      images: [SImages.productImage36, SImages.productImage37],
      salePrice: 290,
      sku: 'ABR4585',
      categoryId: '12',
      productType: 'single',
    ),

    // 019 - Acer
    ProductModel(
      id: '019',
      title: 'Acer Swift Ultrabook 14"',
      stock: 7,
      price: 799,
      isFeatured: true,
      thumbnail: SImages.productImage48,
      description: 'Ultra-thin aluminum chassis laptop with Intel Core processor and 16-hour all-day battery.',
      brand: BrandModel(id: '8', image: SImages.acerlogo, name: 'Acer', productsCount: 12, isFeatured: false),
      images: [SImages.productImage48, SImages.productImage49],
      salePrice: 680,
      sku: 'ABR4586',
      categoryId: '14',
      productType: 'single',
    ),

    // 020 - IKEA
    ProductModel(
      id: '020',
      title: 'Modern Bedroom Bed Frame',
      stock: 8,
      price: 450,
      isFeatured: true,
      thumbnail: SImages.productImage32,
      description: 'Minimalist solid wood king-size bed frame with supportive slatted base and clean headboard.',
      brand: BrandModel(id: '9', image: SImages.ikeaLogo, name: 'IKEA', productsCount: 42, isFeatured: true),
      images: [SImages.productImage32, SImages.productImage43, SImages.productImage44, SImages.productImage46],
      salePrice: 380,
      sku: 'ABR4587',
      categoryId: '11',
      productType: 'single',
    ),

    // 021 - IKEA
    ProductModel(
      id: '021',
      title: 'Three-Door Wooden Wardrobe',
      stock: 5,
      price: 520,
      isFeatured: true,
      thumbnail: SImages.productImage35,
      description: 'Spacious Scandinavian three-door wardrobe with full-height hanging rail and adjustable shelves.',
      brand: BrandModel(id: '9', image: SImages.ikeaLogo, name: 'IKEA', productsCount: 42, isFeatured: true),
      images: [SImages.productImage35],
      salePrice: 440,
      sku: 'ABR4588',
      categoryId: '11',
      productType: 'single',
    ),

    // 022 - Herman Miller
    ProductModel(
      id: '022',
      title: 'Ergonomic High-Back Office Chair',
      stock: 9,
      price: 890,
      isFeatured: true,
      thumbnail: SImages.productImage39,
      description: 'World-renowned ergonomic mesh task chair designed with lumbar support and multi-angle recline.',
      brand: BrandModel(id: '10', image: SImages.hermanMillerLogo, name: 'Herman Miller', productsCount: 18, isFeatured: false),
      images: [SImages.productImage39, SImages.productImage40],
      salePrice: 750,
      sku: 'ABR4589',
      categoryId: '13',
      productType: 'single',
    ),

    // 023 - Herman Miller
    ProductModel(
      id: '023',
      title: 'Electric Standing Work Desk',
      stock: 6,
      price: 650,
      isFeatured: true,
      thumbnail: SImages.productImage41,
      description: 'Heavy duty dual-motor sit-stand adjustable office desk with digital LED memory presets.',
      brand: BrandModel(id: '10', image: SImages.hermanMillerLogo, name: 'Herman Miller', productsCount: 18, isFeatured: false),
      images: [SImages.productImage41, SImages.productImage42],
      salePrice: 540,
      sku: 'ABR4590',
      categoryId: '13',
      productType: 'single',
    ),

    // 024 - Zara
    ProductModel(
      id: '024',
      title: 'Zara Rose Eau De Parfum 100ml',
      stock: 20,
      price: 49,
      isFeatured: true,
      thumbnail: SImages.productImage2,
      description: 'Elegant floral fragrance with notes of peony, blackcurrant and subtle warm vanilla.',
      brand: BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
      images: [SImages.productImage2],
      salePrice: 39,
      sku: 'ABR4591',
      categoryId: '23',
      productType: 'single',
    ),

    // 025 - Zara
    ProductModel(
      id: '025',
      title: 'Deep Hydrating Radiance Facial Cream',
      stock: 18,
      price: 35,
      isFeatured: true,
      thumbnail: SImages.productImage3,
      description: 'Gentle nourishing moisturizer enriched with vitamin C and hyaluronic acid for glowing skin.',
      brand: BrandModel(id: '6', image: SImages.zaraLogo, name: 'Zara', productsCount: 36, isFeatured: true),
      images: [SImages.productImage3],
      salePrice: 28,
      sku: 'ABR4592',
      categoryId: '22',
      productType: 'single',
    ),
  ];
}
