# 네트워크 통신

## 개요

Flutter Financial Chart는 gRPC와 GraphQL을 주요 통신 프로토콜로 사용하며, REST API를 보조적으로 활용합니다. 이를 통해 실시간 데이터 처리와 효율적인 데이터 전송을 구현합니다.

## gRPC

### 1. 프로토콜 정의
```protobuf
syntax = "proto3";

package financial;

service AssetService {
  rpc GetAsset (AssetRequest) returns (Asset);
  rpc WatchPrice (AssetRequest) returns (stream PriceUpdate);
  rpc ExecuteTrade (TradeRequest) returns (TradeResponse);
}

message Asset {
  string id = 1;
  string name = 2;
  double price = 3;
  string currency = 4;
}

message PriceUpdate {
  string asset_id = 1;
  double price = 2;
  string timestamp = 3;
}
```

### 2. 클라이언트 구현
```dart
class GrpcAssetClient {
  late final AssetServiceClient _client;
  
  Future<void> initialize() async {
    final channel = ClientChannel(
      'api.example.com',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.secure(),
      ),
    );
    
    _client = AssetServiceClient(channel);
  }
  
  Stream<PriceUpdate> watchPrice(String assetId) {
    final request = AssetRequest()..id = assetId;
    return _client.watchPrice(request);
  }
}
```

### 3. 에러 처리
```dart
Future<Asset> getAsset(String id) async {
  try {
    final request = AssetRequest()..id = id;
    return await _client.getAsset(request);
  } on GrpcError catch (e) {
    switch (e.code) {
      case StatusCode.notFound:
        throw AssetNotFoundException(id);
      case StatusCode.unavailable:
        throw ServiceUnavailableException();
      default:
        throw GrpcException(e.message);
    }
  }
}
```

## GraphQL

### 1. 스키마 정의
```graphql
type Asset {
  id: ID!
  name: String!
  price: Float!
  currency: String!
  lastUpdate: DateTime!
}

type Query {
  asset(id: ID!): Asset
  assets(filter: AssetFilter): [Asset!]!
}

type Mutation {
  updateAsset(input: UpdateAssetInput!): Asset!
}

type Subscription {
  onPriceUpdate(assetId: ID!): PriceUpdate!
}
```

### 2. 클라이언트 설정
```dart
class GraphQLConfig {
  static final HttpLink httpLink = HttpLink(
    'https://api.example.com/graphql',
  );
  
  static final WebSocketLink wsLink = WebSocketLink(
    'wss://api.example.com/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
    ),
  );
  
  static final Link link = Link.split(
    (request) => request.isSubscription,
    wsLink,
    httpLink,
  );
  
  static final GraphQLClient client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );
}
```

### 3. 쿼리 실행
```dart
class AssetRepository {
  final GraphQLClient _client;
  
  Future<Asset> getAsset(String id) async {
    final result = await _client.query(
      QueryOptions(
        document: gql('''
          query GetAsset(\$id: ID!) {
            asset(id: \$id) {
              id
              name
              price
              currency
            }
          }
        '''),
        variables: {'id': id},
      ),
    );
    
    if (result.hasException) {
      throw GraphQLException(result.exception.toString());
    }
    
    return Asset.fromJson(result.data!['asset']);
  }
}
```

## REST API

### 1. 클라이언트 설정
```dart
class RestClient {
  final Dio _dio;
  
  RestClient() : _dio = Dio() {
    _dio.options.baseUrl = 'https://api.example.com';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(AuthInterceptor());
  }
}
```

### 2. 인터셉터
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = AuthService.getToken();
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
  
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AuthService.refreshToken();
    }
    handler.next(err);
  }
}
```

## 네트워크 보안

### 1. SSL/TLS
- 모든 통신에 HTTPS 사용
- 인증서 피닝 구현
- 안전하지 않은 연결 차단

### 2. 인증
- JWT 토큰 사용
- 토큰 자동 갱신
- 안전한 토큰 저장

### 3. 데이터 보안
- 중요 데이터 암호화
- API 키 보호
- 요청/응답 검증

## 오프라인 지원

### 1. 캐싱 전략
```dart
class CacheManager {
  final Box<dynamic> _box;
  
  Future<T> getCachedData<T>(
    String key,
    Future<T> Function() fetcher,
  ) async {
    final cached = _box.get(key);
    if (cached != null && !isExpired(cached)) {
      return cached as T;
    }
    
    final fresh = await fetcher();
    await _box.put(key, fresh);
    return fresh;
  }
}
```

### 2. 동기화
```dart
class SyncManager {
  Future<void> syncPendingChanges() async {
    final pending = await _getPendingChanges();
    for (final change in pending) {
      try {
        await _uploadChange(change);
        await _markAsSynced(change);
      } catch (e) {
        await _handleSyncError(change, e);
      }
    }
  }
}
```

## 성능 최적화

### 1. 배치 처리
```dart
class BatchProcessor {
  final _queue = <Future Function()>[];
  
  Future<void> addToBatch(Future Function() operation) async {
    _queue.add(operation);
    
    if (_queue.length >= maxBatchSize) {
      await _processBatch();
    }
  }
  
  Future<void> _processBatch() async {
    final batch = _queue.toList();
    _queue.clear();
    
    await Future.wait(batch.map((op) => op()));
  }
}
```

### 2. 연결 관리
```dart
class ConnectionManager {
  final _reconnectController = StreamController<void>();
  
  void initializeConnections() {
    _reconnectController.stream
      .throttle(const Duration(seconds: 5))
      .listen(_handleReconnect);
  }
  
  Future<void> _handleReconnect() async {
    try {
      await _reestablishConnections();
    } catch (e) {
      _scheduleReconnect();
    }
  }
}
```

## 모니터링

### 1. 로깅
```dart
class NetworkLogger {
  static void logRequest(String method, String url, dynamic body) {
    log(
      'Request: $method $url',
      name: 'Network',
      time: DateTime.now(),
      error: body,
    );
  }
  
  static void logError(
    String operation,
    dynamic error,
    StackTrace stackTrace,
  ) {
    log(
      'Error in $operation',
      name: 'Network',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
```

### 2. 메트릭스
```dart
class NetworkMetrics {
  static final _latencyHistogram = Histogram(
    name: 'request_latency',
    help: 'Request latency in milliseconds',
    buckets: [10, 50, 100, 200, 500, 1000],
  );
  
  static void recordLatency(String operation, Duration duration) {
    _latencyHistogram.observe(
      duration.inMilliseconds.toDouble(),
      labels: {'operation': operation},
    );
  }
}
``` 