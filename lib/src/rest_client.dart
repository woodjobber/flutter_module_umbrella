import 'dart:io';
import 'dart:convert' show jsonEncode;
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_module_umbrella/src/base_dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

import 'api_result.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https:/5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/')
abstract class RestClient {
  factory RestClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.instance().dio;
    return _RestClient(dio, baseUrl: baseUrl);
  }

  @Headers({'contentType': 'application/json'})
  @GET('/tasks')
  Future<List<Task>> getTasks();

  @GET('tasks/{id}')
  Future<ApiResult<Task?>> getNestApiResultGenericsInnerTypeNullable();

  @GET('/tasks/{id}')
  Future<List<Task?>> getAutoCastGenericsInnerTypeNullable();

  @GET('/tags')
  Future<List<String>> getTags({
    @Header('optionalHeader') String? optionalHeader,
  });

  @GET('/tasks/{id}')
  Future<Task> getTask(@Path('id') String id);

  @GET('/tags')
  Stream<List<String>> getTagsAsStream();

  @PATCH('/tasks/{id}')
  Future<Task> updateTaskPart(
    @Path() String id,
    @Body() Map<String, dynamic> map,
  );

  @PreventNullToAbsent()
  @PATCH('/tasks/{id}')
  Future<Task> updateTaskAvatar(
      @Path() String id, @Field('avatar') String? avatar);

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path() String id);

  @POST('/tasks')
  Future<Task> createTask(@Body() Task task);

  @POST('/tasks')
  Future<List<Task>> createTasks(@Body() List<Task> tasks);

  @POST('/tasks')
  Future<List<String>> createTaskNames(@Body() List<String> tasks);

  @POST('http://httpbin.org/post')
  Future<void> createNewTaskFromFile(@Part() File file);

  @Headers(<String, String>{'accept': 'image/jpeg'})
  @GET('http://httpbin.org/image/jpeg')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getFile();

  @GET('https://httpbin.org/status/204')
  Future<HttpResponse<void>> responseWith204();

  @POST('http://httpbin.org/post')
  @FormUrlEncoded()
  Future<String> postUrlEncodedFormData(
    @Field() String hello, {
    @Field() required String gg,
  });

  @HEAD('/')
  Future<String> headRequest();

  @GET('/tasks/{id}')
  Future<HttpResponse<List<String?>>> getNestAutoCastBasicInnerTypeNullable();

  @GET('/tasks/{id}')
  Future<HttpResponse<List<String?>>> getAutoCastBasicInnerTypeNullable();

  @POST('/post')
  Future<String> postFormData(
    @Part() Task? task, {
    @Part() required File file,
  });
  @POST('/post')
  Future<String> postFormData2(
    @Part() List<Map<String, dynamic>> task,
    @Part() List<String>? tags,
    @Part(contentType: 'application/json') File file,
  );

  @POST('/post')
  Future<String> postFormData3({
    @Part(value: 'customfiles', contentType: 'application/json')
    required List<File> files,
    @Part(fileName: 'abc.txt') required File file,
  });

  @POST('/post')
  Future<String> postFormData4(@Part() List<Task> tasks, @Part() File file);

  @POST('/post')
  Future<String> postFormData5(
    @Part() List<Task> tasks,
    @Part() Map<String, dynamic> map,
    @Part() int a, {
    @Part() required bool b,
    @Part() required double c,
    @Part() required String d,
  });

  @GET('/demo')
  Future<String> queries(@Queries() Map<String, dynamic> queries);

  @GET('/enums')
  Future<String> queryByEnum(
    @Query('tasks') TaskQuery query,
    @Query("date") DateTime time,
  );

  @GET('/get')
  Future<String> namedExample(
    @Query(r'$apiKey') String apiKey,
    @Query('scope') String scope,
    @Query('type') String type, {
    @Query('from') int? from,
  });
  @POST('/postfile')
  @Headers(<String, dynamic>{
    r'$Content-Type': 'application/octet-stream',
    'Ocp-Apim-Subscription-Key': 'abc'
  })
  Future<String> postFile({@Body() required File file});

  @GET('')
  Future<String> testCustomOptions(@DioOptions() Options options);

  @GET('/cancel')
  Future<String> cancelRequest(@CancelRequest() CancelToken cancelToken);

  @PUT('/sendProgress')
  Future<String> sendProgress(
    @CancelRequest() CancelToken cancelToken, {
    @SendProgress() ProgressCallback? sendProgress,
  });

  @PUT('/receiveProgress')
  Future<String> receiveProgress(
    @CancelRequest() CancelToken cancelToken, {
    @ReceiveProgress() ProgressCallback? receiveProgress,
  });

  @PUT('/boBody')
  @NoBody()
  Future<String> sendWithoutBody();

  @GET('/nestGeneric')
  Future<ValueWrapper<ValueWrapper<String>>> nestGeneric();

  @GET('cache')
  @CacheControl(
    maxAge: 180,
    maxStale: 300,
    minFresh: 60,
    noCache: true,
    noStore: true,
    noTransform: true,
    onlyIfCached: true,
    other: ['public', 'proxy-revalidate'],
  )
  @Headers(<String, String>{'test': 'tes t'})
  Future<String> cache();

  @POST('post')
  Future<String> genericBase(@Body() ValueWrapper<String> request);

  @POST('post')
  Future<String> genericOther(@Body() ValueWrapper<TaskQuery> request);

  @POST('post')
  Future<String> genericMap(@Body() ValueWrapper<Map<String, dynamic>> request);

  @POST('post')
  Future<String> genericListBase(@Body() ValueWrapper<List<String>> request);

  @POST('post')
  Future<String> genericListOther(
    @Body() ValueWrapper<List<TaskQuery>> request,
  );

  @POST('post')
  Future<String> genericListGeneric(
    @Body() ValueWrapper<List<ValueWrapper<TaskQuery>>> request,
  );

  @POST('post')
  Future<String> nestedGenericBase(
    @Body() ValueWrapper<ValueWrapper<String>> request,
  );

  @POST('post')
  Future<String> nestedGenericOther(
    @Body() ValueWrapper<ValueWrapper<TaskQuery>> request,
  );
}

@JsonSerializable()
class Task {
  const Task({
    this.id,
    this.name,
    this.avatar,
    this.createdAt,
  });
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  final String? id;
  final String? name;
  final String? avatar;
  final String? createdAt;

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

// ignore_for_file: constant_identifier_names
enum Status {
  @JsonValue('new')
  New,
  @JsonValue('on_going')
  OnGoing,
  @JsonValue('closed')
  Closed,
}

@JsonSerializable()
class TaskQuery {
  const TaskQuery(this.statuses);

  factory TaskQuery.fromJson(Map<String, dynamic> json) =>
      _$TaskQueryFromJson(json);

  final List<Status> statuses;

  Map<String, dynamic> toJson() => _$TaskQueryToJson(this);
}

@JsonSerializable()
class TaskGroup {
  const TaskGroup({
    required this.date,
    required this.todos,
    required this.completed,
    required this.inProgress,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  final DateTime date;
  final List<Task> todos;
  final List<Task> completed;
  final List<Task> inProgress;

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class ValueWrapper<T> {
  const ValueWrapper({required this.value});

  factory ValueWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ValueWrapperFromJson(json, fromJsonT);

  final T value;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ValueWrapperToJson(this, toJsonT);
}
