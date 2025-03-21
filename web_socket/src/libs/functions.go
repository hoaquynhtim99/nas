package libs

import (
	"fmt"
	"strconv"
	"strings"
)

func Explode(delimiter, text string) []string {
	if len(delimiter) > len(text) {
		return strings.Split(delimiter, text)
	} else {
		return strings.Split(text, delimiter)
	}
}

func Implode(glue string, pieces []string) string {
	return strings.Join(pieces, glue)
}

func InArray(needle interface{}, hystack interface{}) bool {
	switch key := needle.(type) {
	case string:
		for _, item := range hystack.([]string) {
			if key == item {
				return true
			}
		}
	case int:
		for _, item := range hystack.([]int) {
			if key == item {
				return true
			}
		}
	case int64:
		for _, item := range hystack.([]int64) {
			if key == item {
				return true
			}
		}
	default:
		return false
	}
	return false
}

/*
 * Chuyển string đầu vào về list int an toàn để dùng trong SQL IN()
 */
func StrList2IntList(listid string) string {
	list := Explode(",", listid)
	var reslist []string
	for i := range list {
		id, err := strconv.Atoi(list[i])
		if err == nil && !InArray(fmt.Sprint(id), reslist) {
			reslist = append(reslist, fmt.Sprint(id))
		}
	}
	if len(reslist) < 1 {
		return ""
	}

	return Implode(",", reslist)
}
