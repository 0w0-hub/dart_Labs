import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ============================================================
// EXERCISE 1 - Product Model & Repository
// ============================================================

class Product {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'name: $name, '
        'price: \$${price.toStringAsFixed(2)}'
        ')';
  }
}

class ProductRepository {
  // broadcast() allows multiple listeners to listen
  // to the same stream.
  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  // Simulate retrieving products asynchronously.
  Future<List<Product>> getAll() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return [
      Product(
        id: 1,
        name: 'Laptop',
        price: 1200.0,
      ),
      Product(
        id: 2,
        name: 'Keyboard',
        price: 80.0,
      ),
      Product(
        id: 3,
        name: 'Mouse',
        price: 40.0,
      ),
    ];
  }

  // Return a stream that emits newly added products.
  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  // Add a product to the stream.
  void add(Product product) {
    _controller.add(product);
  }

  // Close the stream when it is no longer needed.
  Future<void> dispose() async {
    await _controller.close();
  }
}

Future<void> exercise1() async {
  print('\n==========================================');
  print('EXERCISE 1');
  print('Product Model & Repository');
  print('==========================================\n');

  final repository = ProductRepository();

  // Listen for products added in real time.
  final subscription = repository.liveAdded().listen(
    (product) {
      print('Stream received: $product');
    },
  );

  print('Calling getAll()...');

  // getAll() returns Future<List<Product>>.
  final products = await repository.getAll();

  print('\nProducts returned by getAll():');

  for (final product in products) {
    print('  $product');
  }

  // Simulate real-time product additions.
  print('\nAdding new products...');

  repository.add(
    Product(
      id: 4,
      name: 'Monitor',
      price: 300.0,
    ),
  );

  repository.add(
    Product(
      id: 5,
      name: 'Headset',
      price: 100.0,
    ),
  );

  // Give the event loop time to deliver stream events.
  await Future.delayed(
    const Duration(milliseconds: 100),
  );

  await subscription.cancel();
  await repository.dispose();

  print('\nExercise 1 completed.');
}


// ============================================================
// EXERCISE 2 - User Repository with JSON
// ============================================================

class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  // Convert JSON data into a User object.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() {
    return 'User('
        'name: $name, '
        'email: $email'
        ')';
  }
}

class UserRepository {
  Future<List<User>> getUsers() async {
    // Simulate API/network delay.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    // Simulated JSON response from an API.
    const jsonString = '''
[
  {
    "name": "Alice",
    "email": "alice@example.com"
  },
  {
    "name": "Bob",
    "email": "bob@example.com"
  },
  {
    "name": "Charlie",
    "email": "charlie@example.com"
  }
]
''';

    // JSON string -> List<dynamic>.
    final List<dynamic> jsonList = jsonDecode(
      jsonString,
    );

    // JSON objects -> User objects.
    return jsonList
        .map(
          (json) => User.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}

Future<void> exercise2() async {
  print('\n==========================================');
  print('EXERCISE 2');
  print('User Repository with JSON');
  print('==========================================\n');

  final repository = UserRepository();

  print('Fetching users from simulated API...');

  // getUsers() returns Future<List<User>>.
  final users = await repository.getUsers();

  print('\nUsers received:');

  for (final user in users) {
    print('  $user');
  }

  print('\nExercise 2 completed.');
}


// ============================================================
// EXERCISE 3 - Async + Microtask Debugging
// ============================================================

Future<void> exercise3() async {
  print('\n==========================================');
  print('EXERCISE 3');
  print('Async + Microtask Debugging');
  print('==========================================\n');

  print('1. Synchronous code');

  // Microtask queue.
  scheduleMicrotask(() {
    print('3. Microtask executed');
  });

  // Event queue.
  Future(() {
    print('4. Future event executed');
  });

  print('2. Synchronous code');

  // Wait for scheduled asynchronous callbacks.
  await Future.delayed(
    const Duration(milliseconds: 100),
  );

  // print('\nExpected order:');

  // print('1. Synchronous code');
  // print('2. Synchronous code');
  // print('3. Microtask executed');
  // print('4. Future event executed');

  print(
    '\nExplanation:',
  );

  print(
    'Microtasks are processed before the event queue '
    'continues with the next event.',
  );

  print('\nExercise 3 completed.');
}


// ============================================================
// EXERCISE 4 - Stream Transformation
// ============================================================

Future<void> exercise4() async {
  print('\n==========================================');
  print('EXERCISE 4');
  print('Stream Transformation');
  print('==========================================\n');

  // Create a stream containing numbers 1 through 5.
  final numbers = Stream.fromIterable(
    [1, 2, 3, 4, 5],
  );

  // map() transforms each number into its square.
  //
  // where() filters the transformed values and
  // keeps only even numbers.
  final transformedStream = numbers
      .map(
        (number) => number * number,
      )
      .where(
        (square) => square.isEven,
      );

  print('Original values:');
  print('1, 2, 3, 4, 5');

  print('\nAfter map():');
  print('1, 4, 9, 16, 25');

  print('\nAfter where(square.isEven):');

  // Listen to every emitted value.
  await for (final value in transformedStream) {
    print('  $value');
  }


  print('\nExercise 4 completed.');
}


// ============================================================
// EXERCISE 5 - Factory Constructor & Cache
// ============================================================

class Settings {
  // Cached singleton instance.
  static final Settings _instance =
      Settings._internal();

  // Private constructor.
  Settings._internal();

  // Factory constructor.
  //
  // Instead of creating a new object,
  // return the existing cached instance.
  factory Settings() {
    return _instance;
  }
}

Future<void> exercise5() async {
  print('\n==========================================');
  print('EXERCISE 5');
  print('Factory Constructors & Cache');
  print('==========================================\n');

  final settingsA = Settings();
  final settingsB = Settings();

  print('settingsA: $settingsA');
  print('settingsB: $settingsB');

  // Check whether both variables refer to
  // exactly the same object.
  final result = identical(
    settingsA,
    settingsB,
  );

  print('\nidentical(settingsA, settingsB):');
  print(result);

  if(result)
  print(
    '\nBoth variables refer to the same '
    'singleton instance.',
  );

  print('\nExercise 5 completed.');
}


// ============================================================
// MENU
// ============================================================

void printMenu() {
  print('\n==========================================');
  print('       DART ADVANCED CONCEPTS LAB');
  print('==========================================');
  print('1. Product Model & Repository');
  print('2. User Repository with JSON');
  print('3. Async + Microtask Debugging');
  print('4. Stream Transformation');
  print('5. Factory Constructors & Cache');
  print('0. Exit');
  print('==========================================');
}


// ============================================================
// MAIN
// ============================================================

Future<void> main() async {
  await exercise1();
  await exercise2();
  await exercise3();
  await exercise4();
  await exercise5();
}

void test() async{
  while (true) {
    printMenu();

    stdout.write('Choose an exercise (0-5): ');

    dynamic input = stdin.readLineSync();

    // User selected Exit.
    if (input == '0') {
      print('\nGoodbye!');
      break;
    }

    switch (input) {
      case '1':
        await exercise1();
        break;

      case '2':
        await exercise2();
        break;

      case '3':
        await exercise3();
        break;

      case '4':
        await exercise4();
        break;

      case '5':
        await exercise5();
        break;

      default:
        print(
          '\nInvalid choice.'
          ' Please enter a number from 0 to 5.',
        );
    }

    // Pause before showing the menu again.
    print('\nPress ENTER to return to the menu...');
    stdin.readLineSync();
  }
}
