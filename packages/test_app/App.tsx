import { For, createSignal, onMount } from "solid-js";
import { print, Button, VStack } from "solid-native/core";

export function App() {
  const [count, setCount] = createSignal(0);

  const [itemNumber, setItemNumber] = createSignal(1);

  const [list, setList] = createSignal<string[]>([]);

  setInterval(() => setCount(count() + 1), 1000);

  onMount(() => {
    print("App Mounted!");
  });

  return (
    <VStack>
      Hello World!
      {`Count: ${count()}`}
      <Button
        title="Reset count!"
        onPress={() => {
          setCount(0);
        }}
      />
      <Button
        title="Add some text!"
        onPress={() => {
          setList((prev) => [...prev, "item " + itemNumber()]);
          setItemNumber((prev) => prev + 1);
        }}
      />
      <Button
        title="Reset Text!"
        onPress={() => {
          setList([]);
          setItemNumber(0);
        }}
      />
      <For
        each={list()}
        children={(item) => {
          return item;
        }}
      />
    </VStack>
  );
}
