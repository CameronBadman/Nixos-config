// main.go
package main

import (
	"context"
	"crypto/md5" // triggers deprecated package warning
	"fmt"
	"io/ioutil" // triggers deprecated package warning
	"net/http"
	"sync"
	"sync/atomic"
)

// BadStruct demonstrates fieldalignment issues
type BadStruct struct {
	small   bool    // 1 byte
	large   float64 // 8 bytes
	medium  int32   // 4 bytes
	smaller byte    // 1 byte
}

// GoodStruct demonstrates proper field alignment
type GoodStruct struct {
	large   float64 // 8 bytes
	medium  int32   // 4 bytes
	small   bool    // 1 byte
	smaller byte    // 1 byte
}

// Test useany with multiple interface issues
type MyInterface interface {
	any // should be more specific
}

type BadInterface interface {
	fmt.Stringer
	any // mixing specific and any
}

type MyError struct{}

func (e *MyError) Error() string {
	return "my error"
}

// Functions that handle errors
func errorAsTest() error {
	var err error = &MyError{}
	var target *MyError
	if ok := err.(*MyError); ok != nil { // should use errors.As
		return err
	}
	return target
}

func errorWithoutAs() error {
	return &MyError{}
}

// Functions with unused parameters
func unusedParamFunction(unused string, count int) {
	fmt.Println("Hello")
}

func copyLockFunction(mu sync.Mutex) {
	mu.Lock()
	defer mu.Unlock()
}

func doSomething() string {
	return "doing something"
}

// httpHandler demonstrates http response errors
func httpHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "hello") // should check errors from writes to ResponseWriter
}

func main() {
	// Test error handling
	err := errorAsTest()
	fmt.Println("Error test:", err)

	err = errorWithoutAs()
	var myErr *MyError
	if ok := err.(*MyError); ok != nil { // should use errors.As
		fmt.Println("Error cast failed")
	}

	// Test unusedparams
	unusedParamFunction("test", 42)

	// Test shadow variables
	x := 1
	{
		x := 2 // shadows x
		fmt.Println(x)
	}
	fmt.Println(x)

	// Test nilness
	var ptr *string
	if ptr != nil {
		fmt.Println(*ptr) // potential nil pointer dereference
	}

	// Test atomic operations
	var val int64
	val++ // should use atomic operation
	atomic.AddInt64(&val, 1)

	// Test mutex copying
	var mu sync.Mutex
	copyLockFunction(mu) // passing mutex by value

	// Test boolean simplification
	if true == true { // redundant boolean comparison
		fmt.Println("always true")
	}

	// Test deprecated packages
	data := []byte("test")
	hash := md5.Sum(data)
	fmt.Printf("%x\n", hash)

	content, _ := ioutil.ReadFile("test.txt") // triggers deprecated ioutil warning
	fmt.Println(string(content))

	// Test composites
	var slice = []struct {
		name string
		age  int
	}{
		{name: "test", age: 25},
		{"no key", 30},  // unkeyed composite literal
		{name: "test2"}, // missing field
	}
	fmt.Println(slice)

	// Test printf verbs
	name := "test"
	count := 42
	fmt.Printf("Hello %s %d", name)          // wrong number of args
	fmt.Printf("Hello %d %s", name, count)   // wrong types
	fmt.Printf("Hello %s", 42)               // wrong type
	fmt.Printf("Hello %s %s %s", name, name) // wrong number of args

	// Test context cancellation
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go func() {
		// Lost cancel function in goroutine
		_, cancel := context.WithTimeout(ctx, 0)
		fmt.Println("doing work")
		_ = cancel // cancel is not called
	}()

	// Test struct alignment
	bs := BadStruct{
		small:   true,
		large:   42.0,
		medium:  21,
		smaller: 1,
	}
	fmt.Printf("Bad struct: %+v\n", bs)

	// Test unreachable code
	if false {
		fmt.Println("This is unreachable")
		doSomething()
	}

	http.HandleFunc("/", httpHandler)
}
