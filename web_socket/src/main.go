package main

import (
	"blaNASWebSocket/libs"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/gorilla/websocket"
)

var rooms = make(map[string]*Room)
var mutex = &sync.Mutex{}
var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		// Cho phép tất cả các origin
		return true
	},
}

// Cấu trúc Room đại diện cho một phòng
type Room struct {
	Clients    map[*Client]bool
	Broadcast  chan []byte
	Register   chan *Client
	Unregister chan *Client
}

// Cấu trúc Client đại diện cho một tab mở ra kết nối đến phòng đó
type Client struct {
	ID     string
	Room   *Room
	Conn   *websocket.Conn
	Send   chan []byte
	Name   string
	Avatar string
}

// Cấu trúc message một client mở lên tham gia vào phòng hoặc truy cập 1 phòng rỗng
type RegisterMessage struct {
	Type string `json:"type"`
	Room string `json:"room"`
	Data struct {
		UUID   string `json:"uuid"`
		Name   string `json:"name"`
		Avatar string `json:"avatar"`
	} `json:"data"`
}

// Cấu trúc message một client từ chối lời mời của client khác
type RejectMessage struct {
	Type     string `json:"type"`
	From     string `json:"from"`
	FromName string `json:"from_name"`
	To       string `json:"to"`
}

// Cấu trúc message một client từ chối lời mời của client khác
type CancelOfferMessage struct {
	Type     string `json:"type"`
	From     string `json:"from"`
	FromName string `json:"from_name"`
	To       string `json:"to"`
}

// Cấu trúc message tối giản chỉ có type để kiểm tra
type BaseMessage struct {
	Type string `json:"type"`
}

// Cấu trúc message client gửi đề nghị cho client khác
type OfferMessage struct {
	Type     string          `json:"type"`
	SDP      json.RawMessage `json:"sdp"`
	From     string          `json:"from"`
	FromName string          `json:"from_name"`
	To       string          `json:"to"`
	File     struct {
		Name     string `json:"name"`
		Size     int64  `json:"size"`
		SizeShow string `json:"size_show"`
	} `json:"file"`
}

// Cấu trúc message client trả lời nhận offer của client khác
type AnswerMessage struct {
	Type     string          `json:"type"`
	SDP      json.RawMessage `json:"sdp"`
	From     string          `json:"from"`
	FromName string          `json:"from_name"`
	To       string          `json:"to"`
}

// Cấu trúc message giao tiếp candidate giữa các client
type CandidateMessage struct {
	Type      string          `json:"type"`
	Candidate json.RawMessage `json:"candidate"`
	From      string          `json:"from"`
	FromName  string          `json:"from_name"`
	To        string          `json:"to"`
}

// Xử lý kết nối WebSocket
func handleConnections(w http.ResponseWriter, r *http.Request) {
	// Nâng cấp kết nối HTTP thành WebSocket
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Fatalf("Failed to upgrade to websocket: %v", err)
	}

	client := &Client{
		Conn: conn,
		Send: make(chan []byte, 100),
	}

	go client.ReadMessages()
	go client.WriteMessages()
}

// Hàm xử lý tham gia room, gửi message, loại client khỏi room
func (room *Room) RunRoom(roomID string) {
	for {
		select {
		case client := <-room.Register:
			room.Clients[client] = true
			fmt.Printf("Client %s joined the room\n", client.ID)

			// Gửi danh sách client tới tất cả clients khi có client mới vào
			room.broadcastClientList()

		case client := <-room.Unregister:
			if _, ok := room.Clients[client]; ok {
				close(client.Send)
				delete(room.Clients, client)
				fmt.Printf("Client %s left the room\n", client.ID)
			}

			// Gửi danh sách client tới tất cả clients khi có client rời đi
			room.broadcastClientList()

			// Kiểm tra nếu không còn clients nào trong room
			if len(room.Clients) == 0 {
				fmt.Printf("Room %s is empty, deleting room\n", roomID)
				mutex.Lock()
				delete(rooms, roomID)
				mutex.Unlock()
				return // Dừng goroutine của room
			}

		case message := <-room.Broadcast:
			for client := range room.Clients {
				select {
				case client.Send <- message:
				default:
					close(client.Send)
					delete(room.Clients, client)
				}
			}
		}
	}
}

// Hàm tạo Room mới từ yêu cầu join của client
func createRoom(roomID string) *Room {
	room := &Room{
		Clients:    make(map[*Client]bool),
		Broadcast:  make(chan []byte, 100),
		Register:   make(chan *Client, 100),
		Unregister: make(chan *Client, 100),
	}
	rooms[roomID] = room
	go room.RunRoom(roomID)
	return room
}

// Hàm trả về danh sách client hiện tại trong room
func (room *Room) getClientList() []map[string]string {
	clientList := []map[string]string{}

	for client := range room.Clients {
		clientInfo := map[string]string{
			"uuid":   client.ID,
			"name":   client.Name,
			"avatar": client.Avatar,
		}
		clientList = append(clientList, clientInfo)
	}
	return clientList
}

// Hàm broadcast danh sách clients tới tất cả clients trong room
func (room *Room) broadcastClientList() {
	clientList := room.getClientList()

	// Tạo cấu trúc JSON có type và data
	message := map[string]interface{}{
		"type": "clientsList",
		"data": clientList,
	}

	// Chuyển danh sách clients sang dạng JSON
	messageJSON, err := json.Marshal(message)
	if err != nil {
		log.Println("Error marshaling client list message:", err)
		return
	}

	// Gửi message cho tất cả các clients trong room
	for client := range room.Clients {
		select {
		case client.Send <- messageJSON:
		default:
			log.Println("Error broadcastClientList to client", client.ID)
			close(client.Send)
			delete(room.Clients, client)
		}
	}
}

// Xử lý gửi message cho client
func (client *Client) WriteMessages() {
	defer client.Conn.Close()
	for message := range client.Send {
		err := client.Conn.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			log.Println("Error WriteMessages to client", client.ID)
			break
		}
	}
}

// Xử lý đọc message nhận từ client
func (client *Client) ReadMessages() {
	// Thoát hàm này thì đóng kết nối và hủy client khỏi room
	defer func() {
		if client.Room != nil {
			client.Room.Unregister <- client
		}
		client.Conn.Close()
	}()

	for {
		_, message, err := client.Conn.ReadMessage()
		if err != nil {
			log.Println("Error ReadMessage from client", client.ID)
			break
		}

		// Bỏ qua các ping message
		if string(message) == "0" {
			continue
		}

		var baseMsg BaseMessage
		if err := json.Unmarshal(message, &baseMsg); err != nil {
			log.Println("Error unmarshalling base message:", err)
			continue
		}

		// Xử lý từng loại message
		switch baseMsg.Type {
		case "register":
			// Khi client đăng kí vào -> tạo room (nếu chưa có), add client vào room
			var registerMessage RegisterMessage
			if err := json.Unmarshal(message, &registerMessage); err != nil {
				log.Println("Error unmarshalling registerMessage:", err)
				continue
			}

			roomID := registerMessage.Room
			uuid := registerMessage.Data.UUID
			name := registerMessage.Data.Name
			avatar := registerMessage.Data.Avatar

			// Xử lý việc tham gia room
			client.ID = uuid
			client.Name = name
			client.Avatar = avatar

			mutex.Lock()
			room, ok := rooms[roomID]
			if !ok {
				room = createRoom(roomID)
			}
			mutex.Unlock()

			client.Room = room
			room.Register <- client
		case "offer":
			// Client gửi offer -> chuyển tiếp đến client đích
			var offer OfferMessage
			if err := json.Unmarshal(message, &offer); err != nil {
				log.Println("Error unmarshalling offer message:", err)
				continue
			}

			targetUUID := offer.To
			log.Printf("Message offer from %s and forward to %s\n", client.ID, targetUUID)
			client.Room.forwardMessage(targetUUID, message)
		case "reject":
			// Client từ chối offer của client khác
			var reject RejectMessage
			if err := json.Unmarshal(message, &reject); err != nil {
				log.Println("Error unmarshalling reject message:", err)
				continue
			}

			targetUUID := reject.To
			log.Printf("Message reject from %s and forward to %s\n", client.ID, targetUUID)
			client.Room.forwardMessage(targetUUID, message)

		case "cancel_offer":
			// Client dừng offer sau khi đã gửi offer trước đó
			var cancel_offer CancelOfferMessage
			if err := json.Unmarshal(message, &cancel_offer); err != nil {
				log.Println("Error unmarshalling reject message:", err)
				continue
			}

			targetUUID := cancel_offer.To
			log.Printf("Message cancel_offer from %s and forward to %s\n", client.ID, targetUUID)
			client.Room.forwardMessage(targetUUID, message)

		case "candidate":
			// Trao đổi candidate giữa các client để thiết lập kết nối
			var candidate CandidateMessage
			if err := json.Unmarshal(message, &candidate); err != nil {
				log.Println("Error unmarshalling reject message:", err)
				continue
			}

			targetUUID := candidate.To
			log.Printf("Message candidate from %s and forward to %s\n", client.ID, targetUUID)
			client.Room.forwardMessage(targetUUID, message)

		case "answer":
			// Chuyển trả answer về người gửi offer
			var answerMessage AnswerMessage
			if err := json.Unmarshal(message, &answerMessage); err != nil {
				log.Println("Error parsing answer message:", err)
				continue
			}

			// Xác định client đích và chuyển tiếp thông điệp
			targetUUID := answerMessage.To
			log.Printf("Message answer from %s and forward to %s\n", client.ID, targetUUID)
			client.Room.forwardMessage(targetUUID, message)
		}
	}
}

func (room *Room) forwardMessage(targetUUID string, message []byte) {
	for client := range room.Clients {
		if client.ID == targetUUID {
			select {
			case client.Send <- message:
			default:
				log.Println("Error forwardMessage to client", client.ID)
				close(client.Send)
				delete(room.Clients, client)
			}
			break
		}
	}
}

// Hàm chính
func main() {
	log.Println("Stating application...")

	// Múi giờ
	loc, err := time.LoadLocation(libs.Timezone)
	if err != nil {
		log.Fatalln(err)
	}
	time.Local = loc
	log.Println("Time zone set")

	// Init các cấu hình
	libs.InitConfig()
	log.Println("Config initialized")
	log.Println("Server root " + libs.RootDir)

	http.HandleFunc("/", handleConnections)

	fmt.Println("Signalling server running on :3001")
	err1 := http.ListenAndServe(":3001", nil)
	if err1 != nil {
		log.Fatalf("Server failed: %v", err1)
	}
}
