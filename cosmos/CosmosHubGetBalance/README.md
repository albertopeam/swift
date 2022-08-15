# Using gRPC & Protobuf to connect to Cosmos blockchain

## Install dependencies

* To install profobuf `brew install protobuf`
* To install swift model generator from proto files plugin `brew install swift-protobuf`
* To install swift gRPC API and code generator plugin `brew install grpc-swift`

## Configure xCode project

* Using xCode14
* Add Swift Protobuff as dependency via package manager `https://github.com/apple/swift-protobuf.git`
  * Check only SwiftProtobuf lib
* Add gRPC swift as dependency via package manager`https://github.com/grpc/grpc-swift.git`
  * Check only GRPC lib

## Protobuf messages and services

* Define the proto file with services and messages
  * Create an empty file named `query.proto`
  * Copy the service `AllBalances` from the [cosmoshub profobuf files](https://buf.build/cosmos/cosmos-sdk/file/main:cosmos/bank/v1beta1/query.proto)
  * Copy the `QueryAllBalancesRequest` and `QueryAllBalancesResponse` messages from the [cosmoshub profobuf files](https://buf.build/cosmos/cosmos-sdk/file/main:cosmos/bank/v1beta1/query.proto)
  * Create an empty file named `pagination.proto`
  * Copy dependencies: `PageRequest` and `PageResponse` from the [cosmoshub profobuf files](https://buf.build/cosmos/cosmos-sdk/file/main:cosmos/base/query/v1beta1/pagination.proto)
  * Create an empty file named `cosmos.proto`
  * Copy full file dependencies from [cosmos hub protobuf files](https://buf.build/cosmos/cosmos-proto/file/main:cosmos_proto/cosmos.proto)
  * Create an empty file named `coin.proto`
  * Copy dependencies `Coin` from [cosmos hub protobuf files](https://buf.build/cosmos/cosmos-sdk/file/2f47942f13cd4ecabe7d6a34bfdac562:cosmos/base/v1beta1/coin.proto)
  * Create an empty file named `gogo.proto`
  * Copy dependencies `Gogo` from [cosmos hub protobuf files](https://buf.build/gogo/protobuf/file/main:gogoproto/gogo.proto)
  * NOTE: imports have been edited locally to avoid full path, it should not be done
* Run protoc  
  * Open command line and navigate to root dir `CosmosHubGetBalance`
  * Run command: `protoc ./protobuf/*.proto --proto_path=./protobuf --plugin=swift-protobuf --swift_opt=Visibility=Public --swift_out=./protobuf/generated --plugin=grpc-swift --grpc-swift_opt=Visibility=Public,Client=true,Server=false,TestClient=true,FileNaming=FullPath,KeepMethodCasing=false --grpc-swift_out=./protobuf/generated`
  * This will generate files with `pb.swift` format
  * gRPC-swift plugin options [link](https://github.com/grpc/grpc-swift/blob/main/docs/plugin.md)
  * swift-protobuf plugin options [link](https://github.com/apple/swift-protobuf/blob/main/Documentation/PLUGIN.md#how-to-specify-code-generation-options)

## Import generated pb.swift files into the project

* Add the protobuf directory to the project from xCode
* Write the BankClient to abstract the usage of the gRPC and protofbuf libraries. IMPORTANT: The Cosmos SDK doesn't support any transport security mechanism so .plaintext is OK
* Write the BalanceView to print the balances